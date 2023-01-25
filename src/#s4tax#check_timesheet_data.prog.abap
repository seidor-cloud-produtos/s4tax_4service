*&---------------------------------------------------------------------*
*& Report /s4tax/check_timesheet_data
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /s4tax/check_timesheet_data.

TYPES:

  BEGIN OF y_pedido,
    ebeln TYPE ekko-ebeln,
    ebelp TYPE ekpo-ebelp,
    bukrs TYPE ekko-bukrs,
    werks TYPE ekpo-werks,
    kostl TYPE ekkn-kostl,
    lifnr TYPE ekko-lifnr,
  END OF y_pedido,
  ty_pedido TYPE TABLE OF y_pedido WITH KEY ebeln ebelp.


CLASS main_process DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES: /s4tax/ijob_processor.

    METHODS:
      constructor IMPORTING reporter               TYPE REF TO /s4tax/ireporter OPTIONAL
                            api_4service           TYPE REF TO /s4tax/iapi_4service OPTIONAL
                            dao_pack_partner       TYPE REF TO /s4tax/idao_pack_partner OPTIONAL
                            dao_pack_4service      TYPE REF TO /s4tax/idao_pack_4service OPTIONAL
                            dao_pack_supplier_port TYPE REF TO /s4tax/idao_pack_supplier_port OPTIONAL.

  PROTECTED SECTION.

    DATA:
      reporter TYPE REF TO /s4tax/ireporter.

    METHODS: change_purchase_order IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
                                   RETURNING VALUE(result) TYPE abap_bool,

      call_bapi_transaction_commit,

      call_bapi_transaction_rollback,

      call_bapi_goodsmvt_create IMPORTING goodsmvt_header     TYPE bapi2017_gm_head_01
                                          goodsmvt_code       TYPE bapi2017_gm_code
                                CHANGING  result              TYPE bapiret2_tab
                                          goodsmvt_headret    TYPE bapi2017_gm_head_ret
                                          goodsmvt_item_table TYPE tab_bapi_goodsmvt_item,

      generate_migo IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
                    RETURNING VALUE(result) TYPE abap_bool,

      get_reporter IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
                   RETURNING VALUE(result) TYPE REF TO /s4tax/ireporter,

      call_bapi_po_change IMPORTING poheader  TYPE bapimepoheader
                                    poheaderx TYPE bapimepoheaderx
                                    poitem    TYPE bapimepoitem
                                    poitemx   TYPE bapimepoitemx
                          CHANGING  result    TYPE bapiret2_tab,

      log_bapi_return IMPORTING bapi_return TYPE bapiret2_tab
                                reporter    TYPE REF TO /s4tax/ireporter.

  PRIVATE SECTION.
    DATA:
      api_4service              TYPE REF TO /s4tax/iapi_4service,
      appoint_apvd_by_providers TYPE /s4tax/s_apvd_appoint_list_o,
      dao_pack_4service         TYPE REF TO /s4tax/idao_pack_4service,
      dao_pack_partner          TYPE REF TO /s4tax/idao_pack_partner,
      dao_pack_supplier_port    TYPE REF TO /s4tax/idao_pack_supplier_port.

    METHODS:
      get_api_data IMPORTING initial_date  TYPE REF TO /s4tax/date
                             final_date    TYPE REF TO /s4tax/date
                   RETURNING VALUE(result) TYPE /s4tax/4s_sheet_t,

      process_sheet_list IMPORTING sheet_list         TYPE /s4tax/4s_sheet_t
                                   partner_table      TYPE /s4tax/tpartner_t
                                   pedido_table       TYPE ty_pedido
                                   dao_4service_sheet TYPE REF TO /s4tax/idao_4service_sheet,

      crete_ref_doc_supp_portal IMPORTING sheet         TYPE REF TO /s4tax/4s_sheet
                                RETURNING VALUE(result) TYPE REF TO /s4tax/supp_doc_reference.

ENDCLASS.

CLASS main_process IMPLEMENTATION.

  METHOD constructor.
    DATA: lx_root TYPE REF TO cx_root,
          msg     TYPE string.


    TRY.
        me->reporter = reporter.
        IF me->reporter IS NOT BOUND.
          me->reporter = /s4tax/reporter_factory=>create( object    = /s4tax/reporter_factory=>object-s4tax
                                                          subobject = /s4tax/reporter_factory=>subobject-task ).
        ENDIF.

        me->api_4service = api_4service.
        IF me->api_4service IS INITIAL.
          me->api_4service = /s4tax/api_4service=>get_instance(  ).
        ENDIF.

        me->dao_pack_4service = dao_pack_4service.
        IF me->dao_pack_4service IS INITIAL.
          me->dao_pack_4service = /s4tax/dao_pack_4service=>default_instance(  ).
        ENDIF.

        me->dao_pack_partner = dao_pack_partner.
        IF me->dao_pack_partner IS INITIAL.
          me->dao_pack_partner = /s4tax/dao_pack_partner=>default_instance(  ).
        ENDIF.

        me->dao_pack_supplier_port = dao_pack_supplier_port.
        IF me->dao_pack_supplier_port IS INITIAL.
          me->dao_pack_supplier_port = /s4tax/dao_pack_supplier_port=>default_instance(  ).
        ENDIF.

      CATCH cx_root INTO lx_root.
        msg = lx_root->get_text( ).
        me->reporter->error( msg ).

    ENDTRY.
  ENDMETHOD.

  METHOD /s4tax/ijob_processor~post_process.

  ENDMETHOD.

  METHOD /s4tax/ijob_processor~pre_process.
    DATA: job_utils   TYPE REF TO /s4tax/job_utils,
          job_running TYPE abap_bool.

    CREATE OBJECT job_utils.
    job_running = job_utils->check_job_running( ).

    IF job_running = abap_true.
      RETURN.
    ENDIF.

    result = abap_true.
  ENDMETHOD.

  METHOD /s4tax/ijob_processor~process.
    DATA: sheet_list         TYPE /s4tax/4s_sheet_t,
          fiscal_range       TYPE ace_generic_range_t,
          partner_list       TYPE /s4tax/partner_t,
          partner_table      TYPE /s4tax/tpartner_t,
          order_table        TYPE ty_pedido,
          dao_4service_sheet TYPE REF TO /s4tax/idao_4service_sheet,
          dao_partner        TYPE REF TO /s4tax/idao_partner,
          initial_date       TYPE REF TO /s4tax/date,
          final_date         TYPE REF TO /s4tax/date,
          datum_ini          TYPE datum,
          sheet_table        TYPE /s4tax/t4s_sheet_t,
          range_utils        TYPE REF TO /s4tax/range_utils.


    TRY.
        CREATE OBJECT range_utils.

        datum_ini = '20230101'.
        CREATE OBJECT initial_date EXPORTING date = datum_ini.
        final_date = initial_date->add( days = 30 ).

        sheet_list = get_api_data( initial_date = initial_date final_date = final_date ).

        dao_4service_sheet = me->dao_pack_4service->four_service_sheet( ).
        dao_4service_sheet->save_many( sheet_list ).
        sheet_table = dao_4service_sheet->objects_to_struct( sheet_list ).
        fiscal_range = range_utils->specific_range( low = 'PROVIDER_FISCAL_ID_NUMBER'
                                                    range  = sheet_table[] ).

        dao_partner = me->dao_pack_partner->partner( ).
        partner_list = dao_partner->get_many( fiscal_range ).
        partner_table = dao_partner->object_to_struct( partner_list ).

        SELECT k~ebeln p~ebelp k~bukrs p~werks n~kostl k~lifnr
          INTO TABLE order_table
          FROM ekko AS k
         INNER JOIN ekpo AS p
           ON k~ebeln = p~ebeln
         LEFT JOIN ekkn AS n
           ON n~ebeln = p~ebeln
          FOR ALL ENTRIES IN partner_table
        WHERE k~lifnr = partner_table-parid
          AND k~bstyp = 'F'
          AND p~loekz = ' '
          AND k~aedat BETWEEN initial_date->date
                          AND final_date->date
          AND p~elikz <> 'X'.

        IF sy-subrc <> 0.
          RETURN.
        ENDIF.

        process_sheet_list( sheet_list = sheet_list partner_table = partner_table
                            pedido_table = order_table dao_4service_sheet = dao_4service_sheet ).

      CATCH /s4tax/cx_http.
    ENDTRY.
  ENDMETHOD.

  METHOD get_api_data.

    DATA: appoint_data_list     TYPE /s4tax/s_apprvd_appointments_t,
          appoint_data          TYPE /s4tax/s_apprvd_appointments,
          sheet                 TYPE /s4tax/t4s_sheet,
          service_sheet         TYPE REF TO /s4tax/4s_sheet,
          range_utils           TYPE REF TO /s4tax/range_utils,
          branch                TYPE /s4tax/s_appointments_branches,
          provider              TYPE /s4tax/s_appoint_providers,
          employee              TYPE /s4tax/s_appoint_employees,
          confirm_appointment   TYPE /s4tax/s_confirm_apointments,
          query_params          TYPE /s4tax/s_query_params_t,
          param                 TYPE  /s4tax/s_query_params,
          cx_root               TYPE REF TO cx_root,
          dao_4service_sheet    TYPE REF TO /s4tax/idao_4service_sheet,
          current_4service_list TYPE /s4tax/4s_sheet_t.

    param-name = 'initial_date_commit'. "to-do deixar dinâmico - definir regra com a mari
    param-value = initial_date->to_iso_8601(  ).
    APPEND param TO query_params.

    param-name = 'final_date_commit'.
    param-value = final_date->to_iso_8601(  ). "to-do deixar dinâmico
    APPEND param TO query_params.

    dao_4service_sheet = dao_pack_4service->four_service_sheet(  ).

    current_4service_list = dao_4service_sheet->get_many_by_period( initial_date = initial_date->date
                                                                    final_date   = final_date->date ).

    TRY.
        me->appoint_apvd_by_providers = api_4service->list_appoint_apvd_by_providers( query_params = query_params ).
      CATCH cx_root INTO cx_root.
    ENDTRY.

    appoint_data_list = me->appoint_apvd_by_providers-data.

    LOOP AT appoint_data_list INTO appoint_data.
      sheet-start_period = initial_date->date.
      sheet-end_period   = final_date->date.

      LOOP AT appoint_data-branches INTO branch.
        sheet-branch_id = branch-branch_id.

        LOOP AT branch-providers INTO provider.
          sheet-provider_fiscal_id_number = provider-provider_fiscal_id_number.

          LOOP AT provider-employees INTO employee.
            sheet-employment_erp_code = employee-employment_erp_code.

            LOOP AT employee-confirm_appointments INTO confirm_appointment.
              READ TABLE current_4service_list WITH KEY table_line->struct-appointment_id = confirm_appointment-id TRANSPORTING NO FIELDS.
              IF sy-subrc = 0.
                CONTINUE.
              ENDIF.

              sheet-appointment_id = confirm_appointment-id.
              sheet-approved_value = confirm_appointment-approved_period_income.
              sheet-credat = sy-datum.
              sheet-update_name = sy-uname.

              CREATE OBJECT service_sheet EXPORTING iw_struct = sheet.
              APPEND service_sheet TO result.
            ENDLOOP.
          ENDLOOP.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD process_sheet_list.

    DATA: sheet                 TYPE REF TO /s4tax/4s_sheet,
          s_partner             TYPE /s4tax/tpartner,
          msg                   TYPE string,
          service_reporter      TYPE REF TO /s4tax/ireporter,
          po_change_success     TYPE abap_bool,
          is_generated          TYPE abap_bool,
          pedido                TYPE y_pedido,
          reference_doc         TYPE REF TO /s4tax/supp_doc_reference,
          reference_doc_list    TYPE /s4tax/supp_doc_reference_t,
          dao_sup_doc_reference TYPE REF TO /s4tax/idao_supp_doc_reference.

    LOOP AT sheet_list INTO sheet.
      service_reporter = get_reporter( sheet ).

      READ TABLE partner_table INTO s_partner WITH KEY fiscal_id = sheet->struct-provider_fiscal_id_number.
      IF sy-subrc <> 0 .
        MESSAGE e003(/s4tax/4service) WITH sy-datum sheet->struct-provider_fiscal_id_number
                                           sheet->struct-appointment_id INTO msg.
        sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
        service_reporter->error( msg ).
        CONTINUE.
      ENDIF.

      READ TABLE pedido_table INTO pedido WITH KEY lifnr = s_partner-parid kostl = sheet->struct-employment_erp_code.
      IF sy-subrc <> 0.
        MESSAGE e003(/s4tax/4service) WITH sy-datum sheet->struct-provider_fiscal_id_number
                                           sheet->struct-appointment_id INTO msg.
        sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
        service_reporter->error( msg ).
        CONTINUE.
      ENDIF.
      sheet->set_order_number( pedido-ebeln ).
      sheet->set_order_item( pedido-ebelp ).

      po_change_success = me->change_purchase_order( sheet ).
      IF po_change_success = abap_false.
        sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
        CONTINUE.
      ENDIF.

      is_generated = me->generate_migo( sheet ).
      IF is_generated = abap_false.
        sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
        CONTINUE.
      ENDIF.

      MESSAGE s002(/s4tax/4service) WITH sy-datum sheet->struct-provider_fiscal_id_number
                                          sheet->struct-appointment_id INTO msg.
      service_reporter->success( msg ).
      sheet->set_status( /s4tax/4service_constants=>timesheet_status-finished ).

      reference_doc = me->crete_ref_doc_supp_portal( sheet ).
      APPEND reference_doc TO reference_doc_list.
    ENDLOOP.

    dao_4service_sheet->save_many( sheet_list ).

    dao_sup_doc_reference = dao_pack_supplier_port->supp_doc_reference(  ).
    dao_sup_doc_reference->save_many( reference_doc_list ).

  ENDMETHOD.

  METHOD change_purchase_order.
    DATA: poheader       TYPE bapimepoheader,
          poheaderx      TYPE bapimepoheaderx,
          poitem         TYPE bapimepoitem,
          poitemx        TYPE bapimepoitemx,
          return_table   TYPE STANDARD TABLE OF bapiret2,
          msg            TYPE string,
          reporter_sheet TYPE REF TO /s4tax/ireporter.

    reporter_sheet = service_sheet->get_reporter( ).

    poheader-po_number = service_sheet->struct-order_number.
    poheaderx-po_number = 'X'.

    poitem-po_item = service_sheet->struct-order_item.
    poitemx-po_item = service_sheet->struct-order_item.
    poitem-net_price = service_sheet->struct-approved_value.
    poitemx-net_price = 'X'.
    poitem-gr_ind = 'X'.
    poitemx-gr_ind = 'X'.
    poitem-gr_non_val = 'X'.
    poitemx-gr_non_val = 'X'.

    call_bapi_po_change( EXPORTING poheader = poheader poheaderx = poheaderx poitem = poitem poitemx = poitemx
                         CHANGING result = return_table ).

    READ TABLE return_table TRANSPORTING NO FIELDS WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      result = abap_true.
      call_bapi_transaction_commit( ).
    ELSE.
      MESSAGE e004(/s4tax/4service) WITH sy-datum
                                         service_sheet->struct-provider_fiscal_id_number
                                         service_sheet->struct-order_number INTO msg.
      reporter_sheet->error( msg ).
      call_bapi_transaction_rollback( ).
    ENDIF.

    log_bapi_return( bapi_return = return_table reporter = reporter_sheet ).

  ENDMETHOD.


  METHOD call_bapi_transaction_commit.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDMETHOD.


  METHOD call_bapi_transaction_rollback.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDMETHOD.


  METHOD generate_migo.
    DATA: header            TYPE bapi2017_gm_head_01,
          gm_code           TYPE bapi2017_gm_code,
          item_create_table TYPE tab_bapi_goodsmvt_item,
          migo_created      TYPE bapi2017_gm_head_ret,
          item              TYPE bapi2017_gm_item_create,
          return            TYPE STANDARD TABLE OF bapiret2,
          msg               TYPE string,
          string_utils      TYPE REF TO /s4tax/string_utils,
          reporter_sheet    TYPE REF TO /s4tax/ireporter,
          item_created      TYPE bapi2017_gm_item_create,
          material_created  TYPE /s4tax/t4s_sheet-docref.

    CREATE OBJECT string_utils.
    reporter_sheet = service_sheet->get_reporter( ).

    header-pstng_date = sy-datum.
    header-doc_date = sy-datum.
    header-ref_doc_no = string_utils->concatenate( msg1      = service_sheet->struct-order_number
                                                   msg2      = service_sheet->struct-order_item
                                                   separator = '-' ).
    gm_code = '01'.
    item-move_type = '101'.
    item-po_number = service_sheet->struct-order_number.
    item-po_item   = service_sheet->struct-order_item.
    item-no_more_gr   = 'X'.
    item-mvt_ind =  'B'.

    APPEND item TO item_create_table.

    me->call_bapi_goodsmvt_create( EXPORTING goodsmvt_header = header goodsmvt_code       = gm_code
                                   CHANGING  result = return goodsmvt_item_table = item_create_table goodsmvt_headret = migo_created ).

    READ TABLE return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      call_bapi_transaction_commit( ).
      result = abap_true.

      material_created = migo_created-mat_doc.
      service_sheet->set_docref( material_created ).
      "service_sheet->set_itmref( item_created-matdoc_itm ).
    ELSE.
      service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
      call_bapi_transaction_rollback( ).
      MESSAGE e001(/s4tax/4service) WITH service_sheet->struct-order_number INTO msg.
      reporter_sheet->error( msg ).
    ENDIF.

    log_bapi_return( bapi_return = return reporter = reporter_sheet ).
  ENDMETHOD.

  METHOD call_bapi_goodsmvt_create.
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = goodsmvt_header
        goodsmvt_code    = goodsmvt_code
      IMPORTING
        goodsmvt_headret = goodsmvt_headret
      TABLES
        goodsmvt_item    = goodsmvt_item_table
        return           = result.
  ENDMETHOD.


  METHOD get_reporter.
    result = service_sheet->get_reporter( ).
  ENDMETHOD.


  METHOD call_bapi_po_change.
    DATA: poitem_table  TYPE bapimepoitem_tp,
          poitemx_table TYPE bapimepoitemx_tp.

    APPEND poitem TO poitem_table.
    APPEND poitemx TO poitemx_table.

    CALL FUNCTION 'BAPI_PO_CHANGE'
      EXPORTING
        purchaseorder = poheader-po_number
        poheader      = poheader
        poheaderx     = poheaderx
      TABLES
        return        = result
        poitem        = poitem_table
        poitemx       = poitemx_table.

  ENDMETHOD.


  METHOD log_bapi_return.

    DATA: return TYPE bapiret2,
          msg    TYPE string.

    LOOP AT bapi_return INTO return.
      CONCATENATE return-type return-id return-number return-message INTO msg SEPARATED BY '/'.
      IF return-type = 'E'.
        reporter->error( msg ).
        CONTINUE.
      ENDIF.
      reporter->info( msg ).
    ENDLOOP.

  ENDMETHOD.


  METHOD crete_ref_doc_supp_portal.

    CREATE OBJECT result.
    result->set_docref( sheet->struct-docref ).
    result->set_itmref( sheet->struct-itmref ).
    result->set_credat( sheet->struct-credat ).
    result->set_source( '02' ).
    result->set_updated_name( sy-uname ).

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA: continue_process TYPE abap_bool,
        main_process     TYPE REF TO /s4tax/ijob_processor.

  CASE abap_true.
    WHEN sy-batch.
      CREATE OBJECT main_process TYPE main_process.
    WHEN OTHERS.
      LEAVE PROGRAM.
  ENDCASE.

  continue_process = main_process->pre_process( ).
  IF continue_process = abap_false.
    EXIT.
  ENDIF.

  main_process->process( ).
  main_process->post_process( ).

  INCLUDE /s4tax/check_timesheet_dt_t99 IF FOUND.

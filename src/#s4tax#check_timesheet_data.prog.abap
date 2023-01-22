*&---------------------------------------------------------------------*
*& Report /s4tax/check_timesheet_data
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /s4tax/check_timesheet_data.

TYPES: ty_poitem  TYPE TABLE OF bapimepoitem WITH NON-UNIQUE DEFAULT KEY,
       ty_poitemx TYPE TABLE OF bapimepoitemx WITH NON-UNIQUE DEFAULT KEY,

       BEGIN OF y_pedido,
         ebeln TYPE ekko-ebeln,
         ebelp TYPE ekpo-ebelp,
         bukrs TYPE ekko-bukrs,
         werks TYPE ekpo-werks,
         kostl TYPE ekkn-kostl,
         lifnr TYPE ekko-lifnr,
       END OF y_pedido,
       ty_pedido TYPE TABLE OF y_pedido,

       BEGIN OF y_pedido_poitem,
         ebeln   TYPE ekko-ebeln,
         ebelp   TYPE ekpo-ebelp,
         bukrs   TYPE ekko-bukrs,
         werks   TYPE ekpo-werks,
         kostl   TYPE ekkn-kostl,
         lifnr   TYPE ekko-lifnr,
         poitem  TYPE ty_poitem,
         poitemx TYPE ty_poitemx,
       END OF y_pedido_poitem,
       ty_pedido_poitem TYPE TABLE OF y_pedido_poitem WITH KEY ebeln.

CLASS main_process DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES: /s4tax/ijob_processor.

    METHODS:
      constructor IMPORTING reporter          TYPE REF TO /s4tax/ireporter OPTIONAL
                            api_4service      TYPE REF TO /s4tax/iapi_4service OPTIONAL
                            dao_pack_partner  TYPE REF TO /s4tax/idao_pack_partner OPTIONAL
                            dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service OPTIONAL.

  PROTECTED SECTION.

    DATA:
      reporter                  TYPE REF TO /s4tax/ireporter.

    METHODS:
      change_purchase_order IMPORTING pedido_po_item TYPE y_pedido_poitem
                                      service_sheet  TYPE REF TO /s4tax/4s_sheet
                            RETURNING VALUE(result)  TYPE abap_bool,

      call_bapi_transaction_commit,

      call_bapi_transaction_rollback,

      call_bapi_goodsmvt_create IMPORTING goodsmvt_header     TYPE bapi2017_gm_head_01
                                          goodsmvt_code       TYPE bapi2017_gm_code
                                CHANGING  result              TYPE bapiret2_tab
                                          goodsmvt_item_table TYPE tab_bapi_goodsmvt_item,

      generate_migo IMPORTING pedido_item   TYPE y_pedido_poitem
                              service_sheet TYPE REF TO /s4tax/4s_sheet
                    RETURNING VALUE(result) TYPE abap_bool,

      get_reporter IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
                   RETURNING VALUE(result) TYPE REF TO /s4tax/ireporter,

      call_bapi_po_change IMPORTING pedido_po_item TYPE y_pedido_poitem
                                    poheader       TYPE bapimepoheader
                                    poheaderx      TYPE bapimepoheaderx
                          RETURNING VALUE(result)  TYPE bapiret2_tab,

      log_bapi_return IMPORTING bapi_return TYPE bapiret2_tab
                                reporter    TYPE REF TO /s4tax/ireporter.

  PRIVATE SECTION.
    DATA:
      api_4service              TYPE REF TO /s4tax/iapi_4service,
      appoint_apvd_by_providers TYPE /s4tax/s_apvd_appoint_list_o,
      dao_pack_4service         TYPE REF TO /s4tax/idao_pack_4service,
      dao_pack_partner          TYPE REF TO /s4tax/idao_pack_partner.

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
    DATA: appoint_data_list   TYPE /s4tax/s_apprvd_appointments_t,
          appoint_data        TYPE /s4tax/s_apprvd_appointments,
          sheet               TYPE /s4tax/t4s_sheet,
          service_sheet       TYPE REF TO /s4tax/4s_sheet,
          service_sheet_list  TYPE /s4tax/4s_sheet_t,
          fiscal_range        TYPE ace_generic_range_t,
          range_utils         TYPE REF TO /s4tax/range_utils,
          branch              TYPE /s4tax/s_appointments_branches,
          provider            TYPE /s4tax/s_appoint_providers,
          employee            TYPE /s4tax/s_appoint_employees,
          confirm_appointment TYPE /s4tax/s_confirm_apointments,
          partner_list        TYPE /s4tax/partner_t,
          partner_table       TYPE /s4tax/tpartner_t,
          s_partner           TYPE /s4tax/tpartner,
          it_pedido           TYPE ty_pedido,
          it_pedido_poitem    TYPE ty_pedido_poitem,
          poitem              TYPE bapimepoitem,
          poitemx             TYPE bapimepoitemx,
          pedido_item         TYPE y_pedido_poitem,
          start_period        TYPE sy-datum,
          end_period          TYPE sy-datum,
          msg                 TYPE string,
          service_reporter    TYPE REF TO /s4tax/ireporter,
          po_change_success   TYPE abap_bool,
          is_generated        TYPE abap_bool,
          dao_4service_sheet  TYPE REF TO /s4tax/idao_4service_sheet,
          dao_partner         TYPE REF TO /s4tax/idao_partner,
          query_params        TYPE /s4tax/s_query_params_t,
          param               TYPE  /s4tax/s_query_params,
          initial_date        TYPE REF TO /s4tax/date,
          final_date          TYPE REF TO /s4tax/date.

    FIELD-SYMBOLS:
      <pedido_tab> TYPE ty_pedido_poitem,
      <wa_pedido>  TYPE y_pedido_poitem.

    CREATE OBJECT range_utils.
    TRY.

        CREATE OBJECT initial_date EXPORTING date = '01012023'.
        param-name = 'initial_date_commit'.
        param-value = initial_date->to_iso_8601(  ). "to-do deixar dinâmico - definir regra com a mari
        APPEND param TO query_params.

        final_date = initial_date->add( days = 30 ).
        param-name = 'final_date_commit'.
        param-value = final_date->to_iso_8601(  ). "to-do deixar dinâmico
        APPEND param TO query_params.

        me->appoint_apvd_by_providers = api_4service->list_appoint_apvd_by_providers( query_params = query_params ).

        appoint_data_list = me->appoint_apvd_by_providers-data.

        LOOP AT appoint_data_list INTO appoint_data.
          sheet-start_period = appoint_data-period-start_period.
          sheet-end_period   = appoint_data-period-end_period.

          LOOP AT appoint_data-branches INTO branch.
            sheet-branch_id = branch-branch_id.

            LOOP AT branch-providers INTO provider.
              sheet-provider_fiscal_id_number = provider-provider_fiscal_id_number.
              fiscal_range = range_utils->append_single_value( low = sheet-provider_fiscal_id_number
                                                               range  = fiscal_range ).

              LOOP AT provider-employees INTO employee.
                sheet-employment_erp_code = employee-employment_erp_code.

                LOOP AT employee-confirm_appointments INTO confirm_appointment.
                  sheet-appointment_id = confirm_appointment-id.
                  sheet-approved_value = confirm_appointment-approved_period_income.
                  sheet-credat = sy-datum.
                  sheet-update_name = sy-uname.

                  CREATE OBJECT service_sheet EXPORTING iw_struct = sheet.
                  APPEND service_sheet TO service_sheet_list.
                ENDLOOP.
              ENDLOOP.
            ENDLOOP.
          ENDLOOP.
        ENDLOOP.

        dao_4service_sheet = me->dao_pack_4service->four_service_sheet( ).
        dao_4service_sheet->save_many( service_sheet_list ).

        dao_partner = me->dao_pack_partner->partner( ).
        partner_list = dao_partner->get_many( fiscal_range ).
        partner_table = dao_partner->object_to_struct( partner_list ).

        start_period = initial_date->date.
        end_period = final_date->date.

        SELECT k~ebeln p~ebelp k~bukrs p~werks n~kostl k~lifnr
          INTO TABLE it_pedido
          FROM ekko AS k
         INNER JOIN ekpo AS p
           ON k~ebeln = p~ebeln
         LEFT JOIN ekkn AS n
           ON n~ebeln = p~ebeln
          FOR ALL ENTRIES IN partner_table
        WHERE k~lifnr = partner_table-parid
          AND k~bstyp = 'F'
          AND p~loekz = ' '
          AND k~aedat BETWEEN start_period
                          AND end_period
          AND p~elikz <> 'X'.

        IF sy-subrc <> 0.
          RETURN.
        ENDIF.

        MOVE-CORRESPONDING it_pedido TO it_pedido_poitem.
        ASSIGN it_pedido_poitem TO <pedido_tab>.

        LOOP AT service_sheet_list INTO service_sheet.
          service_reporter = get_reporter( service_sheet ).

          READ TABLE partner_table WITH KEY fiscal_id = service_sheet->struct-provider_fiscal_id_number INTO s_partner.
          IF sy-subrc <> 0 .
            MESSAGE s003(/s4tax/4service) WITH service_sheet->struct-update_at
                                               service_sheet->struct-provider_fiscal_id_number
                                               service_sheet->struct-appointment_id INTO msg.

            service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
            service_reporter->error( msg ).
            CONTINUE. "to do logar
          ENDIF.

          READ TABLE <pedido_tab> ASSIGNING <wa_pedido> WITH KEY lifnr = s_partner-parid
                                                                 kostl = service_sheet->struct-employment_erp_code.
          IF sy-subrc <> 0.
            MESSAGE s003(/s4tax/4service) WITH service_sheet->struct-update_at
                                               service_sheet->struct-provider_fiscal_id_number
                                               service_sheet->struct-appointment_id INTO msg.

            service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
            service_reporter->error( msg ).
            CONTINUE. "to do logar
          ENDIF.
          service_sheet->set_order_number( <wa_pedido>-ebeln ).
          service_sheet->set_order_item( <wa_pedido>-ebelp ).

          poitem-po_item = <wa_pedido>-ebelp.
          poitemx-po_item = <wa_pedido>-ebelp.

          poitem-net_price = <wa_pedido>-kostl.
          poitemx-net_price = 'X'.

          poitem-gr_ind = 'X'.
          poitemx-gr_ind = 'X'.

          poitem-gr_non_val = 'X'.
          poitemx-gr_non_val = 'X'.

          APPEND poitem TO <wa_pedido>-poitem.
          APPEND poitemx TO <wa_pedido>-poitemx.
        ENDLOOP.


        LOOP AT it_pedido_poitem INTO pedido_item.
          READ TABLE partner_table INTO s_partner WITH KEY parid = pedido_item-lifnr.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          READ TABLE service_sheet_list INTO service_sheet WITH KEY table_line->struct-provider_fiscal_id_number = s_partner-fiscal_id
                                                                    table_line->struct-employment_erp_code = pedido_item-kostl.
          service_reporter = get_reporter( service_sheet ).

          IF sy-subrc <> 0.
            MESSAGE s003(/s4tax/4service) WITH service_sheet->struct-update_at
                                               service_sheet->struct-provider_fiscal_id_number
                                               service_sheet->struct-appointment_id INTO msg.

            service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
            service_reporter->error( msg ).
            CONTINUE.
          ENDIF.

          po_change_success = me->change_purchase_order( pedido_po_item = pedido_item service_sheet = service_sheet ).
          IF po_change_success = abap_false.
            service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
            CONTINUE.
          ENDIF.

          is_generated = me->generate_migo( pedido_item = pedido_item service_sheet = service_sheet ).
          IF is_generated = abap_false.
            service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
            CONTINUE.
          ENDIF.

          service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-finished ).

        ENDLOOP.

        dao_4service_sheet->save_many( service_sheet_list ).

      CATCH /s4tax/cx_http.
    ENDTRY.
  ENDMETHOD.

  METHOD change_purchase_order.
    DATA: poheader       TYPE bapimepoheader,
          poheaderx      TYPE bapimepoheaderx,
          return_table   TYPE STANDARD TABLE OF bapiret2,
          msg            TYPE string,
          reporter_sheet TYPE REF TO /s4tax/ireporter.

    reporter_sheet = service_sheet->get_reporter( ).

    poheader-po_number = pedido_po_item-ebeln.
    poheaderx-po_number = 'X'.

    return_table = call_bapi_po_change( pedido_po_item = pedido_po_item poheader = poheader poheaderx = poheaderx ).

    READ TABLE return_table TRANSPORTING NO FIELDS WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      result = abap_true.
      call_bapi_transaction_commit( ).
    ELSE.
      MESSAGE e004(/s4tax/4service) WITH pedido_po_item-ebeln INTO msg.
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
    header-ref_doc_no = string_utils->concatenate( msg1      = pedido_item-ebeln
                                                   msg2      = pedido_item-ebelp
                                                   separator = '-' ).
    gm_code = '01'.
    item-move_type = '101'.
    item-po_number = pedido_item-ebeln.
    item-po_item   = pedido_item-ebelp.
    APPEND item TO item_create_table.

    me->call_bapi_goodsmvt_create( EXPORTING goodsmvt_header = header goodsmvt_code       = gm_code
                                   CHANGING  result = return goodsmvt_item_table = item_create_table ).

    READ TABLE return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      call_bapi_transaction_commit( ).
      result = abap_true.

      READ TABLE item_create_table INTO item_created INDEX 1.
      material_created = item_created-material.
      service_sheet->set_docref( material_created ).
      "service_sheet->set_itmref( item_created-matdoc_itm ).
    ELSE.
      service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
      call_bapi_transaction_rollback( ).
      MESSAGE e001(/s4tax/4service) WITH pedido_item-ebeln INTO msg.
      reporter_sheet->error( msg ).
    ENDIF.

    log_bapi_return( bapi_return = return reporter = reporter_sheet ).
  ENDMETHOD.

  METHOD call_bapi_goodsmvt_create.
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header = goodsmvt_header
        goodsmvt_code   = goodsmvt_code
      TABLES
        goodsmvt_item   = goodsmvt_item_table
        return          = result.
  ENDMETHOD.


  METHOD get_reporter.
    result = service_sheet->get_reporter( ).
  ENDMETHOD.


  METHOD call_bapi_po_change.

    CALL FUNCTION 'BAPI_PO_CHANGE'
      EXPORTING
        purchaseorder = poheader-po_number
        poheader      = poheader
        poheaderx     = poheaderx
      TABLES
        return        = result
        poitem        = pedido_po_item-poitem
        poitemx       = pedido_po_item-poitemx.

  ENDMETHOD.


  METHOD log_bapi_return.

    DATA return TYPE bapiret2.
    DATA msg TYPE string.

    LOOP AT bapi_return INTO return.
      CONCATENATE return-type return-id return-number return-message INTO msg SEPARATED BY '/'.
      IF return-type = 'E'.
        reporter->error( msg ).
        CONTINUE.
      ENDIF.
      reporter->info( msg ).
    ENDLOOP.

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

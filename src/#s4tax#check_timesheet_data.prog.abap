*&---------------------------------------------------------------------*
*& Report /s4tax/check_timesheet_data
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /s4tax/check_timesheet_data.

CLASS main_process DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES: /s4tax/ijob_processor.

    METHODS:
      constructor IMPORTING reporter               TYPE REF TO /s4tax/ireporter OPTIONAL
                            api_4service           TYPE REF TO /s4tax/iapi_4service OPTIONAL
                            dao_pack_partner       TYPE REF TO /s4tax/idao_pack_partner OPTIONAL
                            dao_pack_4service      TYPE REF TO /s4tax/idao_pack_4service OPTIONAL
                            dao_pack_supplier_port TYPE REF TO /s4tax/idao_pack_supplier_port OPTIONAL
                            dao_pack_gen_data      TYPE REF TO /s4tax/idao_pack_gen_data OPTIONAL.

  PROTECTED SECTION.

    DATA:
      reporter TYPE REF TO /s4tax/ireporter.

    METHODS:
      change_purchase_order IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
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

      log_bapi_return IMPORTING bapi_return   TYPE bapiret2_tab
                                reporter      TYPE REF TO /s4tax/ireporter
                      RETURNING VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
    DATA:
      api_4service              TYPE REF TO /s4tax/iapi_4service,
      appoint_apvd_by_providers TYPE /s4tax/s_apvd_appoint_list_o,
      dao_pack_4service         TYPE REF TO /s4tax/idao_pack_4service,
      dao_pack_partner          TYPE REF TO /s4tax/idao_pack_partner,
      dao_pack_supplier_port    TYPE REF TO /s4tax/idao_pack_supplier_port,
      dao_pack_gen_data         TYPE REF TO /s4tax/idao_pack_gen_data.

    METHODS:
      get_api_data IMPORTING initial_date  TYPE REF TO /s4tax/date
                             final_date    TYPE REF TO /s4tax/date
                   RETURNING VALUE(result) TYPE /s4tax/4s_sheet_t,

      get_last_day_of_month IMPORTING date          TYPE datum
                            RETURNING VALUE(result) TYPE datum,

      process_sheet_list IMPORTING sheet_list         TYPE /s4tax/4s_sheet_t
                                   partner_table      TYPE /s4tax/tpartner_t
                                   pedido_table       TYPE /s4tax/idal_purchasing_doc=>tsimple_purchase
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

        me->dao_pack_gen_data = dao_pack_gen_data.
        IF me->dao_pack_gen_data IS INITIAL.
          me->dao_pack_gen_data = /s4tax/dao_pack_gen_data=>default_instance( ).
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
          order_table        TYPE /s4tax/idal_purchasing_doc=>tsimple_purchase,
          dao_4service_sheet TYPE REF TO /s4tax/idao_4service_sheet,
          dao_partner        TYPE REF TO /s4tax/idao_partner,
          initial_date       TYPE REF TO /s4tax/date,
          final_date         TYPE REF TO /s4tax/date,
          sheet_table        TYPE /s4tax/t4s_sheet_t,
          dal_purchasing_doc TYPE REF TO /s4tax/idal_purchasing_doc,
          range_utils        TYPE REF TO /s4tax/range_utils.


    TRY.
        CREATE OBJECT range_utils.
        CREATE OBJECT initial_date EXPORTING date = sy-datum.
        initial_date = initial_date->subtract( months  = 1 ).

        final_date = initial_date->last_day_of_month(  ).

        sheet_list = get_api_data( initial_date = initial_date final_date = final_date ).

        dao_4service_sheet = me->dao_pack_4service->four_service_sheet( ).
        dao_4service_sheet->save_many( sheet_list ).
        sheet_table = dao_4service_sheet->objects_to_struct( sheet_list ).
        fiscal_range = range_utils->specific_range( low = 'PROVIDER_FISCAL_ID_NUMBER'
                                                    range  = sheet_table[] ).

        dao_partner = me->dao_pack_partner->partner( ).
        partner_list = dao_partner->get_many( fiscal_range ).
        partner_table = dao_partner->object_to_struct( partner_list ).

        dal_purchasing_doc = dao_pack_gen_data->purchasing_document_dal(  ).

        order_table = dal_purchasing_doc->get_simple_purchase(
                        partner_table = partner_table
                        initial_date  = initial_date->date
                        final_date    = final_date->date
                      ).

        process_sheet_list( sheet_list = sheet_list partner_table = partner_table
                            pedido_table = order_table dao_4service_sheet = dao_4service_sheet ).
        result = abap_true.
      CATCH /s4tax/cx_http.
    ENDTRY.
  ENDMETHOD.

  METHOD get_api_data.

    DATA: appoint_data_list     TYPE /s4tax/s_apprvd_appointments_t,
          appoint_data          TYPE /s4tax/s_apprvd_appointments,
          sheet                 TYPE /s4tax/t4s_sheet,
          service_sheet         TYPE REF TO /s4tax/4s_sheet,
          branch                TYPE /s4tax/s_appointments_branches,
          provider              TYPE /s4tax/s_appoint_providers,
          employee              TYPE /s4tax/s_appoint_employees,
          confirm_appointment   TYPE /s4tax/s_confirm_apointments,
          query_params          TYPE /s4tax/s_query_params_t,
          param                 TYPE  /s4tax/s_query_params,
          cx_root               TYPE REF TO cx_root,
          dao_4service_sheet    TYPE REF TO /s4tax/idao_4service_sheet,
          current_4service_list TYPE /s4tax/4s_sheet_t,
          string_utils          TYPE REF TO /s4tax/string_utils,
          date_formatted        TYPE string,
          start_date            TYPE datum,
          end_date              TYPE datum.

    param-name = /s4tax/4service_constants=>params-initial_date_commit. "to-do deixar dinâmico - definir regra com a mari
    param-value = initial_date->to_iso_8601(  ).
    APPEND param TO query_params.

    param-name = /s4tax/4service_constants=>params-final_date_commit.
    param-value = final_date->to_iso_8601(  ). "to-do deixar dinâmico
    APPEND param TO query_params.

    dao_4service_sheet = dao_pack_4service->four_service_sheet(  ).

    current_4service_list = dao_4service_sheet->get_many_by_period( initial_date = initial_date->date
                                                                    final_date   = final_date->date ).
    CREATE OBJECT string_utils.
    TRY.
        me->appoint_apvd_by_providers = api_4service->list_appoint_apvd_by_providers( query_params = query_params ).
      CATCH cx_root INTO cx_root.
    ENDTRY.

    appoint_data_list = me->appoint_apvd_by_providers-data.

    LOOP AT appoint_data_list INTO appoint_data.

      date_formatted = string_utils->replace_characters( appoint_data-period-start_period ).
      start_date = date_formatted(8).

      date_formatted = string_utils->replace_characters( appoint_data-period-end_period ).
      end_date = date_formatted(8).

      sheet-start_period = start_date.
      sheet-end_period   = end_date.

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
          pedido                TYPE /s4tax/idal_purchasing_doc=>simple_purchase,
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
    DATA: return_table       TYPE STANDARD TABLE OF bapiret2,
          msg                TYPE string,
          dal_4service_sheet TYPE REF TO /s4tax/idal_4service_sheet,
          reporter_sheet     TYPE REF TO /s4tax/ireporter.


    dal_4service_sheet = dao_pack_4service->dal_4service_sheet(  ).
    return_table = dal_4service_sheet->change_purchase_order( service_sheet ).

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

    result = log_bapi_return( bapi_return = return_table reporter = reporter_sheet ).

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
    DATA: return             TYPE STANDARD TABLE OF bapiret2,
          msg                TYPE string,
          reporter_sheet     TYPE REF TO /s4tax/ireporter,
          dal_4service_sheet TYPE REF TO /s4tax/idal_4service_sheet.

    dal_4service_sheet = me->dao_pack_4service->dal_4service_sheet(  ).

    return = dal_4service_sheet->generate_migo( service_sheet ).

    READ TABLE return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      call_bapi_transaction_commit( ).
      result = abap_true.
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
        result = abap_false.
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
    result->set_source( /s4tax/4service_constants=>source-pedido_compra ).
    result->set_updated_name( sy-uname ).

  ENDMETHOD.

  METHOD get_last_day_of_month.
    CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
      EXPORTING
        day_in            = date
      IMPORTING
        last_day_of_month = result
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
    ENDIF.
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

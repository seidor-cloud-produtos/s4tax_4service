*&---------------------------------------------------------------------*
*& Report /s4tax/check_timesheet_data
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /s4tax/check_timesheet_data.

TYPES: ty_poitem                  TYPE TABLE OF bapimepoitem WITH NON-UNIQUE DEFAULT KEY,
       ty_poitemx                 TYPE TABLE OF bapimepoitemx WITH NON-UNIQUE DEFAULT KEY,
       ty_bapiret2                TYPE TABLE OF bapiret2 WITH NON-UNIQUE DEFAULT KEY,
       ty_bapi2017_gm_item_create TYPE TABLE OF bapi2017_gm_item_create WITH NON-UNIQUE DEFAULT KEY,

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

    METHODS: constructor IMPORTING reporter          TYPE REF TO /s4tax/ireporter OPTIONAL
                                   api_4service      TYPE REF TO /s4tax/iapi_4service OPTIONAL
                                   dao_pack_partner  TYPE REF TO /s4tax/idao_pack_partner OPTIONAL
                                   dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service OPTIONAL.

  PROTECTED SECTION.
    DATA: reporter                  TYPE REF TO /s4tax/ireporter.

    METHODS: call_bapi_po_change IMPORTING purchaseorder TYPE bapimepoheader-po_number
                                           poitem        TYPE ty_poitem OPTIONAL
                                           poitemx       TYPE ty_poitemx OPTIONAL
                                 RETURNING VALUE(result) TYPE ty_bapiret2,
      call_bapi_transaction_commit,
      call_bapi_transaction_rollback,
      call_bapi_goodsmvt_create IMPORTING goodsmvt_header     TYPE bapi2017_gm_head_01
                                          goodsmvt_code       TYPE bapi2017_gm_code
                                          goodsmvt_item_table TYPE ty_bapi2017_gm_item_create
                                RETURNING VALUE(result)       TYPE ty_bapiret2,

      generate_migo IMPORTING pedido_item TYPE y_pedido_poitem,
      get_reporter IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
                   RETURNING VALUE(result) TYPE REF TO /s4tax/ireporter.

  PRIVATE SECTION.
    DATA: api_4service              TYPE REF TO /s4tax/iapi_4service,
          appoint_apvd_by_providers TYPE /s4tax/s_apvd_appoint_list_o,
          dao_pack_4service         TYPE REF TO /s4tax/idao_pack_4service,
          dao_pack_partner          TYPE REF TO /s4tax/idao_pack_partner,
          dao_4service_sheet        TYPE REF TO /s4tax/idao_4service_sheet,
          dao_partner               TYPE REF TO /s4tax/idao_partner.

ENDCLASS.

CLASS main_process IMPLEMENTATION.

  METHOD constructor.
    DATA: lx_root  TYPE REF TO cx_root,
          msg      TYPE string,
          api_auth TYPE REF TO /s4tax/iapi_auth,
          defaults TYPE REF TO /s4tax/defaults,
          session  TYPE REF TO /s4tax/session.

    TRY.
        me->reporter = reporter.
        IF me->reporter IS NOT BOUND.
          me->reporter = /s4tax/reporter_factory=>create( object    = /s4tax/reporter_factory=>object-s4tax
                                                          subobject = /s4tax/reporter_factory=>subobject-task ).
        ENDIF.
      CATCH cx_root INTO lx_root.
        msg = lx_root->get_text( ).
        me->reporter->error( msg ).
    ENDTRY.

    defaults      = /s4tax/defaults=>get_default_instance( ).
    api_auth      = /s4tax/api_auth=>default_instance( ).

    me->api_4service = api_4service.
    IF me->api_4service IS INITIAL.
      TRY.
          session       = api_auth->login( /s4tax/defaults=>customer_profile_name ).
          CREATE OBJECT me->api_4service TYPE /s4tax/api_4service EXPORTING session = session.
        CATCH /s4tax/cx_http /s4tax/cx_auth.
      ENDTRY.
    ENDIF.

    me->dao_pack_4service = dao_pack_4service.
    IF me->dao_pack_4service IS INITIAL.
      me->dao_pack_4service = /s4tax/dao_pack_4service=>default_instance(  ).
    ENDIF.

    me->dao_4service_sheet = me->dao_pack_4service->four_service_sheet(  ).

    me->dao_pack_partner = dao_pack_partner.
    IF me->dao_pack_partner IS INITIAL.
      me->dao_pack_partner = /s4tax/dao_pack_partner=>default_instance(  ).
    ENDIF.

    me->dao_partner = me->dao_pack_partner->partner(  ).
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
          sheet_table         TYPE /s4tax/t4s_sheet_t,
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
          pedido              TYPE y_pedido,
          return_table        TYPE STANDARD TABLE OF bapiret2,
          poitem              TYPE bapimepoitem,
          poitemx             TYPE bapimepoitemx,
          pedido_item         TYPE y_pedido_poitem,
          start_period        TYPE sy-datum,
          end_period          TYPE sy-datum,
          msg                 TYPE string,
          return              TYPE bapiret2,
          reporter            TYPE REF TO /s4tax/ireporter.

    FIELD-SYMBOLS:
      <pedido_tab> TYPE ty_pedido_poitem,
      <wa_pedido>  TYPE y_pedido_poitem,
      <sheet_tab>  TYPE /s4tax/t4s_sheet_t,
      <sheet>      TYPE /s4tax/t4s_sheet.

    CREATE OBJECT range_utils.
    TRY.
        me->appoint_apvd_by_providers = api_4service->list_appoint_apvd_by_providers( ).

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

                  CREATE OBJECT service_sheet EXPORTING iw_struct = sheet.
                  APPEND service_sheet TO service_sheet_list.
                ENDLOOP.
              ENDLOOP.
            ENDLOOP.
          ENDLOOP.
        ENDLOOP.

        me->dao_4service_sheet->save_many( service_sheet_list ).
        sheet_table = me->dao_4service_sheet->objects_to_struct( service_sheet_list ).

        partner_list = me->dao_partner->get_many( fiscal_range ).
        partner_table = me->dao_partner->object_to_struct( partner_list ).

        start_period = appoint_data-period-start_period.
        end_period = appoint_data-period-end_period.

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
          READ TABLE partner_table WITH KEY fiscal_id = service_sheet->struct-provider_fiscal_id_number INTO s_partner.
          IF sy-subrc <> 0 .
            reporter = get_reporter( service_sheet ).
            MESSAGE s003(/s4tax/4service) WITH service_sheet->struct-update_at
                                      service_sheet->struct-provider_fiscal_id_number
                                      service_sheet->struct-appointment_id INTO msg.
            reporter->error( msg ).
            service_sheet->set_reporter( reporter ).
            service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
            CONTINUE. "to do logar
          ENDIF.

          READ TABLE <pedido_tab> ASSIGNING <wa_pedido> WITH KEY lifnr = s_partner-parid
                                                                 kostl = service_sheet->struct-employment_erp_code.
          IF sy-subrc <> 0.
            reporter = get_reporter( service_sheet ).
            MESSAGE s003(/s4tax/4service) WITH service_sheet->struct-update_at
                                      service_sheet->struct-provider_fiscal_id_number
                                      service_sheet->struct-appointment_id INTO msg.
            reporter->error( msg ).
            service_sheet->set_reporter( reporter ).
            service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
            CONTINUE. "to do logar
          ENDIF.

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

        ASSIGN sheet_table TO <sheet_tab>.

        LOOP AT it_pedido_poitem INTO pedido_item.
          READ TABLE partner_table INTO s_partner WITH KEY parid = pedido_item-lifnr.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          READ TABLE <sheet_tab> ASSIGNING <sheet> WITH KEY provider_fiscal_id_number = s_partner-fiscal_id
                                                            employment_erp_code = pedido_item-kostl.

          CREATE OBJECT service_sheet EXPORTING iw_struct = <sheet>.

          IF sy-subrc <> 0.
            reporter = get_reporter( service_sheet ).
            MESSAGE s003(/s4tax/4service) WITH <sheet>-update_at
                                               <sheet>-provider_fiscal_id_number
                                               <sheet>-appointment_id INTO msg.
            reporter->error( msg ).
            service_sheet->set_reporter( reporter ).
            service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
            <sheet> = service_sheet->struct.
            CONTINUE.
          ENDIF.

          return_table = me->call_bapi_po_change( purchaseorder = pedido-ebeln
                                                  poitem        = pedido_item-poitem
                                                  poitemx       = pedido_item-poitemx ).

          READ TABLE return_table TRANSPORTING NO FIELDS WITH KEY type = 'E'.

          IF sy-subrc <> 0.
            call_bapi_transaction_commit( ).
            generate_migo( pedido_item ).
            <sheet>-status = /s4tax/4service_constants=>timesheet_status-finished.
            reporter = get_reporter( service_sheet ).
            service_sheet->set_reporter( reporter ).
            <sheet> = service_sheet->struct.
            CONTINUE.
          ENDIF.

          "TO DO logar
          call_bapi_transaction_rollback( ).
          DELETE return_table WHERE type <> 'E'.
          MESSAGE e000(/s4tax/4service) WITH pedido_item-ebeln INTO msg.
          me->reporter->error( msg ).

          LOOP AT return_table INTO return.
            CONCATENATE return-type return-id return-number return-message INTO msg SEPARATED BY '/'.
            me->reporter->error( msg ).
          ENDLOOP.
        ENDLOOP.

        service_sheet_list = me->dao_4service_sheet->struct_to_objects( sheet_table ).
        me->dao_4service_sheet->save_many( service_sheet_list ).

      CATCH /s4tax/cx_http.
    ENDTRY.
  ENDMETHOD.

  METHOD call_bapi_po_change.
    DATA: poheader  TYPE bapimepoheader,
          poheaderx TYPE bapimepoheaderx.

    poheader-po_number = purchaseorder.
    poheaderx-po_number = 'X'.

    CALL FUNCTION 'BAPI_PO_CHANGE'
      EXPORTING
        purchaseorder = purchaseorder
        poheader      = poheader
        poheaderx     = poheaderx
      TABLES
        return        = result
        poitem        = poitem
        poitemx       = poitemx.
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
          item_create_table TYPE STANDARD TABLE OF bapi2017_gm_item_create,
          item              TYPE bapi2017_gm_item_create,
          return            TYPE STANDARD TABLE OF bapiret2,
          msg               TYPE string,
          wa_return         TYPE bapiret2,
          string_utils      TYPE REF TO /s4tax/string_utils.

    CREATE OBJECT string_utils.

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

    return = call_bapi_goodsmvt_create( goodsmvt_header     = header
                                        goodsmvt_code       = gm_code
                                        goodsmvt_item_table = item_create_table ).

    READ TABLE return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      call_bapi_transaction_commit( ).
      "to do logar
      RETURN.
    ENDIF.

    call_bapi_transaction_rollback( ).
    DELETE return WHERE type <> 'E'.
    MESSAGE e001(/s4tax/4service) WITH pedido_item-ebeln INTO msg.
    reporter->error( msg ).

    LOOP AT return INTO wa_return.
      CONCATENATE wa_return-type wa_return-id wa_return-number wa_return-message INTO msg SEPARATED BY '/'.
      reporter->error( msg ).
    ENDLOOP.
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
    DATA: msg        TYPE string.

    result = service_sheet->get_reporter( ).

    IF result IS BOUND.
      RETURN.
    ENDIF.

    result = /s4tax/reporter_factory=>create( object    =  /s4tax/reporter_factory=>object-s4tax
                                              subobject = /s4tax/reporter_factory=>subobject-four_service  ).

    MESSAGE s002(/s4tax/4service) WITH service_sheet->struct-update_at
                                       service_sheet->struct-provider_fiscal_id_number
                                       service_sheet->struct-appointment_id INTO msg.
    result->info( msg ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA: continue_process TYPE abap_bool,
        main_process     TYPE REF TO /s4tax/ijob_processor.

  continue_process = main_process->pre_process( ).
  IF continue_process = abap_false.
    EXIT.
  ENDIF.

  main_process->process( ).
  main_process->post_process( ).

  INCLUDE /s4tax/check_timesheet_dt_t99 IF FOUND.

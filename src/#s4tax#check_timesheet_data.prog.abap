*&---------------------------------------------------------------------*
*& Report /s4tax/check_timesheet_data
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /s4tax/check_timesheet_data.

CLASS main_process DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES: /s4tax/ijob_processor.

    METHODS: constructor IMPORTING reporter          TYPE REF TO /s4tax/ireporter OPTIONAL
                                   api_4service      TYPE REF TO /s4tax/iapi_4service OPTIONAL
                                   dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: reporter                  TYPE REF TO /s4tax/ireporter,
          api_4service              TYPE REF TO /s4tax/iapi_4service,
          appoint_apvd_by_providers TYPE /s4tax/s_apvd_appoint_list_o,
          dao_pack_4service         TYPE REF TO /s4tax/idao_pack_4service,
          dao_4service_sheet        TYPE REF TO /s4tax/idao_4service_sheet.

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
          t4s_sheet           TYPE /s4tax/t4s_sheet,
          t4s_sheet_table     TYPE /s4tax/t4s_sheet_t,
          service_sheet_list  TYPE /s4tax/4s_sheet_t,
          branch              TYPE /s4tax/s_appointments_branches,
          provider            TYPE /s4tax/s_appoint_providers,
          employee            TYPE /s4tax/s_appoint_employees,
          confirm_appointment TYPE /s4tax/s_confirm_apointments.

    TRY.
        me->appoint_apvd_by_providers = api_4service->list_appoint_apvd_by_providers( ).

        appoint_data_list = me->appoint_apvd_by_providers-data.

        LOOP AT appoint_data_list INTO appoint_data.
          t4s_sheet-start_period = appoint_data-period-start_period.
          t4s_sheet-end_period   = appoint_data-period-end_period.

          LOOP AT appoint_data-branches INTO branch.
            t4s_sheet-branch_id = branch-branch_id.

            LOOP AT branch-providers INTO provider.
              t4s_sheet-provider_fiscal_id_number = provider-provider_fiscal_id_number.

              LOOP AT provider-employees INTO employee.
                t4s_sheet-employment_erp_code = employee-employment_erp_code.

                LOOP AT employee-confirm_appointments INTO confirm_appointment.
                  t4s_sheet-appointment_id = confirm_appointment-id.
                  t4s_sheet-approved_value = confirm_appointment-approved_period_income.

                  APPEND t4s_sheet TO t4s_sheet_table.
                ENDLOOP.
              ENDLOOP.
            ENDLOOP.
          ENDLOOP.
        ENDLOOP.

        service_sheet_list = me->dao_4service_sheet->struct_to_objects( t4s_sheet_table ).
        me->dao_4service_sheet->save_many( service_sheet_list ).

        "Loop em appoint_apvd_by_providers
        "criar o registro da nova tabela e setar os valores
        "enloop
        "

        "buscar fornecedores
        "Verificar se está bloqueado? sperm <> 'X'
        "buscar empresas/filiais
        "buscar pedidos

      CATCH /s4tax/cx_http.
    ENDTRY.
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

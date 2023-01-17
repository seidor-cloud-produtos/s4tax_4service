*&---------------------------------------------------------------------*
*& Report /s4tax/check_timesheet_data
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /s4tax/check_timesheet_data.

CLASS main_process DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES: /s4tax/ijob_processor.

    METHODS: constructor IMPORTING reporter TYPE REF TO /s4tax/ireporter OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: reporter                  TYPE REF TO /s4tax/ireporter,
          api_4service              TYPE REF TO /s4tax/iapi_4service,
          appoint_apvd_by_providers TYPE /s4tax/s_apvd_appoint_list_o.

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

    TRY.
        session       = api_auth->login( /s4tax/defaults=>customer_profile_name ).
        CREATE OBJECT api_4service TYPE /s4tax/api_4service EXPORTING session = session.
      CATCH /s4tax/cx_http /s4tax/cx_auth.
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
    TRY.
        me->appoint_apvd_by_providers = api_4service->list_appoint_apvd_by_providers( ).

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

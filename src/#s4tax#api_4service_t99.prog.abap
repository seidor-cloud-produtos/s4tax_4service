*&---------------------------------------------------------------------*
*& Include /s4tax/api_4service_t99
*&---------------------------------------------------------------------*
CLASS ltcl_api_4service DEFINITION
  INHERITING FROM /s4tax/api_signed_test
  FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: cut TYPE REF TO /s4tax/api_4service.

    METHODS:
      setup,
      mount_exp_branch RETURNING VALUE(result) TYPE /s4tax/s_appointments_branches,
      mount_exp_provider RETURNING VALUE(result) TYPE /s4tax/s_appoint_providers,
      mount_exp_employees RETURNING VALUE(result) TYPE /s4tax/s_appoint_employees,
      mount_exp_confirm_appoint RETURNING VALUE(result) TYPE /s4tax/s_confirm_apointments,

      list_appoint_apvd_by_providers FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_api_4service IMPLEMENTATION.

  METHOD setup.
    DATA: defaults TYPE REF TO /s4tax/defaults.

    mount_data(  ).
    mock_configuration(  ).

    defaults = NEW #( mock_dao_pack ).

    cut = NEW #( session = session defaults = defaults ).
  ENDMETHOD.

  METHOD list_appoint_apvd_by_providers.
    DATA: expected      TYPE /s4tax/s_apvd_appoint_list_o,
          exp_data_list TYPE /s4tax/s_apprvd_appointments_t,
          exp_data      TYPE /s4tax/s_apprvd_appointments,
          exp_branches  TYPE /s4tax/s_appoint_branches_t,
          exp_period    TYPE /s4tax/s_approval_period.

    DATA(cdata) = '{' &&
                      '"data": [' &&
                          '{' &&
                              '"period": {' &&
                                  '"start_period": "16-01-2023",' &&
                                  '"end_period": "16-04-2023"' &&
                              '},' &&
                              '"branches": [' &&
                              '{' &&
                                  '"branch_id": "8ecb27a5-9f54-40d3-8751-27f17a04837a",' &&
                                  '"fiscal_number_id": "77167",' &&
                                  '"employment_branch_name": "Branch name",' &&
                                  '"providers": [' &&
                                      '{' &&
                                          '"provider_fiscal_id_number": "66773730000133",' &&
                                          '"provider_name": "Provider name",' &&
                                          '"employees": [' &&
                                              '{' &&
                                                  '"employment_erp_code": "5c04b20d-0f26-4561-9818-bdec49d1e2c9",' &&
                                                  '"employee_name": "Nome do colaborador que realizou o aceite",' &&
                                                  '"confirm_appointments": [' &&
                                                      '{' &&
                                                          '"id": "5c04b20d-0f26-4561-9818-bdec49d1e2c9",' &&
                                                          '"updated_at": "16-01-2023",' &&
                                                          '"approved_period_income": "230.00"' &&
                                                      '}' &&
                                                  ']' &&
                                              '}' &&
                                          ']' &&
                                      '}' &&
                                  ']' &&
                              '}' &&
                          ']' &&
                      '}' &&
                  ']' &&
                '}'.

    response->if_http_response~set_cdata( data = cdata ).

    APPEND mount_exp_branch( ) TO exp_branches.
    exp_data-branches = exp_branches.

    exp_period-start_period = '16-01-2023'.
    exp_period-end_period = '16-04-2023'.
    exp_data-period = exp_period.

    APPEND exp_data TO exp_data_list.
    expected-data = exp_data_list.

    DATA(output) = cut->/s4tax/iapi_4service~list_appoint_apvd_by_providers(  ).

    cl_abap_unit_assert=>assert_equals( exp = expected act = output ).
  ENDMETHOD.

  METHOD mount_exp_branch.
    result-branch_id = '8ecb27a5-9f54-40d3-8751-27f17a04837a'.
    result-fiscal_number_id = '77167'.
    result-employment_branch_name = 'Branch name'.
    APPEND mount_exp_provider( ) TO result-providers.
  ENDMETHOD.

  METHOD mount_exp_provider.
    result-provider_fiscal_id_number = '66773730000133'.
    result-provider_name = 'Provider name'.
    APPEND mount_exp_employees( ) TO result-employees.
  ENDMETHOD.

  METHOD mount_exp_employees.
    result-employment_erp_code = '5c04b20d-0f26-4561-9818-bdec49d1e2c9'.
    result-employee_name = 'Nome do colaborador que realizou o aceite'.
    APPEND mount_exp_confirm_appoint( ) TO result-confirm_appointments.
  ENDMETHOD.

  METHOD mount_exp_confirm_appoint.
    result-id = '5c04b20d-0f26-4561-9818-bdec49d1e2c9'.
    result-updated_at = '16-01-2023'.
    result-approved_period_income = '230.00'.
  ENDMETHOD.

ENDCLASS.

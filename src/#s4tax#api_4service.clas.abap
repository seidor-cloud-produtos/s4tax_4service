CLASS /s4tax/api_4service DEFINITION
  PUBLIC
    INHERITING FROM /s4tax/api_signed_service
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES /s4tax/iapi_4service.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF api_paths,
        list_approved_appointments     TYPE string VALUE 'https://hom.api.orbitspot.com/officeservice/api/time-sheet-confirm-appointments/providers-approved-period-income',
        list_worked_hours_by_providers TYPE string VALUE 'https://hom.api.orbitspot.com/officeservice/api/time-sheet-confirm-appointments',
      END OF api_paths.
ENDCLASS.



CLASS /s4tax/api_4service IMPLEMENTATION.
  METHOD /s4tax/iapi_4service~list_appoint_apvd_by_providers.
    DATA: config_generator TYPE REF TO /s4tax/json_config_generator,
          json_config      TYPE REF TO /s4tax/json_element_config,
          request_dto      TYPE REF TO /s4tax/request,
          context_id       TYPE /s4tax/trequest-context_id.

    request_dto = create_custom_request_dto( context    = /s4tax/constants=>context-service
                                             context_id = context_id ).

    create_request_obj(
      EXPORTING
        session     = me->session
        http_path   = api_paths-list_approved_appointments
        http_method = /s4tax/http_operation=>http_methods-get
        request_dto = request_dto
      CHANGING
        output      = result
        request     = last_request
    ).

    CREATE OBJECT config_generator EXPORTING name_to_camel = abap_false.
    json_config = config_generator->generate_data_type_config( result ).

    last_request->add_prop( name = /s4tax/http_request=>commom_props_name-response_element_config
                            obj  = json_config ).

    last_request->send(  ).
  ENDMETHOD.

  METHOD /s4tax/iapi_4service~list_worked_hours_by_providers.
    DATA: config_generator TYPE REF TO /s4tax/json_config_generator,
          json_config      TYPE REF TO /s4tax/json_element_config,
          request_dto      TYPE REF TO /s4tax/request,
          context_id       TYPE /s4tax/trequest-context_id.

    request_dto = create_custom_request_dto( context    = /s4tax/constants=>context-service
                                             context_id = context_id ).

    create_request_obj(
      EXPORTING
        session     = me->session
        http_path   = api_paths-list_worked_hours_by_providers
        http_method = /s4tax/http_operation=>http_methods-get
        request_dto = request_dto
      CHANGING
        output      = result
        request     = last_request
    ).

    CREATE OBJECT config_generator EXPORTING name_to_camel = abap_false.
    json_config = config_generator->generate_data_type_config( result ).

    last_request->add_prop( name = /s4tax/http_request=>commom_props_name-response_element_config
                            obj  = json_config ).

    last_request->send(  ).
  ENDMETHOD.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Include /s4tax/partner_create_4srv_t99
*&---------------------------------------------------------------------*
CLASS ltcl_partner_create_4srv DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CONSTANTS: interface_dao_pack_partner TYPE seoclsname VALUE '/S4TAX/IDAO_PACK_PARTNER',
               interface_dal_partner      TYPE seoclname  VALUE '/S4TAX/IDAL_PARTNER'.

    CLASS-DATA: mock_dao_pack_partner TYPE REF TO /s4tax/idao_pack_partner,
                mock_dal_partner      TYPE REF TO /s4tax/idal_partner.

    DATA: cut           TYPE REF TO /s4tax/partner_create_4service,
          partners      TYPE /s4tax/partner_t.

    METHODS:
      setup,
      mock_configuration,
      mount_customer RETURNING VALUE(result) TYPE REF TO /s4tax/customer,
      mount_provider RETURNING VALUE(result) TYPE REF TO /s4tax/supplier,
      mount_partner RETURNING VALUE(result) TYPE REF TO /s4tax/partner,

      select            FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_partner_create_4srv IMPLEMENTATION.

  METHOD setup.
    mock_dao_pack_partner ?= cl_abap_testdouble=>create( interface_dao_pack_partner ).
    mock_dal_partner      ?= cl_abap_testdouble=>create( interface_dal_partner ).

    cut = NEW #( dao_pack_partner = mock_dao_pack_partner ).
  ENDMETHOD.

  METHOD select.
    DATA: partner TYPE REF TO /s4tax/partner.

    partner = mount_partner(  ).
    APPEND partner TO partners.
    mock_configuration(  ).

    cut->/s4tax/ipartner_create~select(  ).
    cl_abap_unit_assert=>assert_not_initial( cut->get_partners(  ) ).
  ENDMETHOD.

  METHOD mock_configuration.
    cl_abap_testdouble=>configure_call( mock_dao_pack_partner )->returning( mock_dal_partner )->ignore_all_parameters(  ).
    mock_dao_pack_partner->partner_dal(  ).

    cl_abap_testdouble=>configure_call( mock_dal_partner )->returning( partners )->ignore_all_parameters(  ).
    mock_dal_partner->get_partner_create_4service(  ).
  ENDMETHOD.

  METHOD mount_customer.
    result = NEW #(  ).
    result->set_kunnr( 'parid' ).
    result->set_name1( 'Razão Social CUSTOMER X' ).
    result->set_name2( 'Nome Fantasia CUSTOMER X' ).
    result->set_stcd1( 'CNPJ CUSTOMER X' ).
  ENDMETHOD.

  METHOD mount_provider.
    result  = NEW #(  ).
    result->set_lifnr( 'parid' ).
    result->set_name1( 'Razão Social PROVIDER A' ).
    result->set_name2( 'Nome Fantasia PROVIDER A' ).
    result->set_stcd1( 'CNPJ PROVIDER A' ).
  ENDMETHOD.

  METHOD mount_partner.
    DATA: customer TYPE REF TO /s4tax/customer,
          provider TYPE REF TO /s4tax/supplier.

    customer = mount_customer(  ).
    provider = mount_provider(  ).

    result = NEW #(  ).
    result->set_customer( customer ).
    result->set_provider( provider ).
    result->set_parid( 'parid' ).
  ENDMETHOD.

ENDCLASS.

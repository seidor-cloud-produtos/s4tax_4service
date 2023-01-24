*&---------------------------------------------------------------------*
*& Include /s4tax/dao_mkpf_t99
*&---------------------------------------------------------------------*
CLASS ltcl_dao_mkpf DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA: db_mock    TYPE REF TO if_osql_test_environment,
                mkpf_table TYPE /s4tax/tmkpf_t.

    DATA: cut TYPE REF TO /s4tax/dao_mkpf.

    CLASS-METHODS:
      class_setup,
      class_teardown.

    METHODS:
      setup,
      teardown.

    METHODS:
      save      FOR TESTING RAISING cx_static_check,
      get_many_by_material_doc FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_dao_mkpf IMPLEMENTATION.

  METHOD class_setup.
    db_mock = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'MKPF' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    db_mock->destroy( ).
  ENDMETHOD.

  METHOD setup.

    cut = NEW #(  ).

    mkpf_table = VALUE #(
    ( mblnr = '12345'
      mjahr = '2023' )

    ( mblnr = '12346'
      mjahr = '2022' ) ).

    db_mock->insert_test_data( mkpf_table ).
  ENDMETHOD.

  METHOD teardown.
    db_mock->clear_doubles( ).
  ENDMETHOD.

  METHOD get_many_by_material_doc.
    DATA: material              TYPE REF TO /s4tax/mkpf,
          range_utils           TYPE REF TO /s4tax/range_utils,
          material_number_range TYPE ace_generic_range_t,
          act                   TYPE /s4tax/mkpf_t.

    range_utils = NEW #(  ).
    material_number_range = range_utils->append_single_value( low  = '12346' range  = material_number_range ).

    act = cut->/s4tax/idao_mkpf~get_many_by_material_doc(
                  material_number_range = material_number_range
                  material_year         = '2022'
                ).

    cl_abap_unit_assert=>assert_equals( exp = 1 act = lines( act ) ).


    act = cut->/s4tax/idao_mkpf~get_many_by_material_doc(
                  material_number_range = material_number_range
                  material_year         = '2025'
                ).

    cl_abap_unit_assert=>assert_equals( exp = 0 act = lines( act ) ).

  ENDMETHOD.

  METHOD save.
    DATA: material              TYPE REF TO /s4tax/mkpf,
          range_utils           TYPE REF TO /s4tax/range_utils,
          material_number_range TYPE ace_generic_range_t.

    range_utils = NEW #(  ).
    material_number_range = range_utils->append_single_value( low    = '123456' range  = material_number_range ).

    material = NEW #(  ).
    material->set_mblnr( '123456' ).
    material->set_mjahr( '2023' ).

    cut->/s4tax/idao_mkpf~save( material ).

    DATA(act) = cut->/s4tax/idao_mkpf~get_many_by_material_doc(
                  material_number_range = material_number_range
                  material_year         = '2023'
                ).

    cl_abap_unit_assert=>assert_equals( exp = 1 act = lines( act ) ).
  ENDMETHOD.

ENDCLASS.

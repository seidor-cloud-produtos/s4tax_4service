*&---------------------------------------------------------------------*
*& Include /s4tax/dal_material_doc_t99
*&---------------------------------------------------------------------*

CLASS ltcl_dal_material_doc DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS: interface_dao_pack_4service    TYPE seoclsname VALUE '/S4TAX/IDAO_PACK_4SERVICE',
               interface_dao_material_doc     TYPE seoclsname VALUE '/S4TAX/IDAO_MATERIAL_DOCUMENT',
               interface_dao_material_doc_seg TYPE seoclsname VALUE '/S4TAX/IDAO_MATERIAL_DOC_SEG'.

    CLASS-DATA: mock_dao_pack_4service     TYPE REF TO /s4tax/idao_pack_4service,
                mock_dao_material_document TYPE REF TO /s4tax/idao_material_document,
                mock_dao_material_doc_seg  TYPE REF TO /s4tax/idao_material_doc_seg.

    DATA: cut                     TYPE REF TO /s4tax/dal_material_document,

          material_doc_seg_list   TYPE /s4tax/material_document_seg_t,
          material_document_list  TYPE /s4tax/material_document_t,
          material_document_table TYPE /s4tax/tmaterial_document_t.

    METHODS:
      setup,
      mount_data,
      mock_configuration,
      fill_mat_doc_seg_many_mat_doc FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_dal_material_doc IMPLEMENTATION.

  METHOD fill_mat_doc_seg_many_mat_doc.
    DATA: act TYPE /s4tax/material_document_seg_t.

    act = cut->/s4tax/idal_material_document~fill_mat_doc_seg_many_mat_doc( material_document_list = material_document_list ).
    cl_abap_unit_assert=>assert_equals( exp = 1 act = lines( act ) ).

    CLEAR me->material_doc_seg_list.
    mock_configuration(  ).

    act = cut->/s4tax/idal_material_document~fill_mat_doc_seg_many_mat_doc( material_document_list = material_document_list ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = lines( act ) ).

    CLEAR me->material_document_list.
    act = cut->/s4tax/idal_material_document~fill_mat_doc_seg_many_mat_doc( material_document_list = material_document_list ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = lines( act ) ).
  ENDMETHOD.

  METHOD setup.
    mock_dao_pack_4service ?= cl_abap_testdouble=>create( interface_dao_pack_4service ).
    mock_dao_material_document ?= cl_abap_testdouble=>create( interface_dao_material_doc ).
    mock_dao_material_doc_seg ?= cl_abap_testdouble=>create( interface_dao_material_doc_seg ).

    mount_data(  ).
    mock_configuration(  ).
    cut = NEW #( dao_pack_4service = mock_dao_pack_4service ).
  ENDMETHOD.

  METHOD mock_configuration.
    DATA: generic_range      TYPE ace_generic_range_t.

    cl_abap_testdouble=>configure_call( mock_dao_pack_4service )->returning( mock_dao_material_document )->ignore_all_parameters( ).
    mock_dao_pack_4service->material_document( ).

    cl_abap_testdouble=>configure_call( mock_dao_pack_4service )->returning( mock_dao_material_doc_seg )->ignore_all_parameters( ).
    mock_dao_pack_4service->material_doc_seg( ).

    cl_abap_testdouble=>configure_call( mock_dao_material_doc_seg )->returning( material_doc_seg_list )->ignore_all_parameters( ).
    mock_dao_material_doc_seg->get_many_by_material( generic_range ).

    cl_abap_testdouble=>configure_call( mock_dao_material_document )->returning( material_document_table )->ignore_all_parameters( ).
    mock_dao_material_document->objects_to_struct( material_document_list ).

  ENDMETHOD.

  METHOD mount_data.
    DATA: material_doc_seg  TYPE REF TO /s4tax/material_document_seg,
          material_doc      TYPE mkpf,
          material_document TYPE REF TO /s4tax/material_document.

    material_document = NEW #(  ).
    material_document->set_mblnr( '12345' ).
    material_document->set_mjahr( '2023' ).
    APPEND material_document TO me->material_document_list.

    material_document = NEW #(  ).
    material_document->set_mblnr( '12365' ).
    material_document->set_mjahr( '2021' ).
    APPEND material_document TO me->material_document_list.

    material_doc_seg = NEW #(  ).
    material_doc_seg->set_mblnr( '12345' ).
    material_doc_seg->set_mjahr( '2023' ).
    material_doc_seg->set_zeile( '1222' ).
    APPEND material_doc_seg TO me->material_doc_seg_list.

    material_doc-mblnr = '12345'.
    material_doc-mjahr = '2023'.
    APPEND material_doc TO me->material_document_table.

    material_doc-mblnr = '12346'.
    material_doc-mjahr = '2022'.
    APPEND material_doc TO me->material_document_table.
  ENDMETHOD.

ENDCLASS.

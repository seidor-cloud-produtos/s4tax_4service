*&---------------------------------------------------------------------*
*& Include /s4tax/dal_4service_sheet_t99
*&---------------------------------------------------------------------*
CLASS ltcl_dal_4service_sheet DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: cut           TYPE REF TO /s4tax/dal_4service_sheet,
          return_table  TYPE bapiret2_tab,
          service_sheet TYPE REF TO /s4tax/4s_sheet.

    CONSTANTS: interface_dao_pack_4service  TYPE seoclsname VALUE '/S4TAX/IDAO_PACK_4SERVICE',
               interface_material_doc_dal   TYPE seoclsname VALUE '/S4TAX/IDAL_MATERIAL_DOCUMENT',
               interface_dao_pack_gen_data  TYPE seoclsname VALUE '/S4TAX/IDAO_PACK_GEN_DATA',
               interface_purchasing_doc_dal TYPE seoclsname VALUE '/S4TAX/IDAL_PURCHASING_DOC'.

    CLASS-DATA: mock_dao_pack_4service     TYPE REF TO /s4tax/idao_pack_4service,
                mock_material_document_dal TYPE REF TO /s4tax/idal_material_document,
                mock_dao_pack_gen_data     TYPE REF TO /s4tax/idao_pack_gen_data,
                mock_purchasing_doc_dal    TYPE REF TO /s4tax/idal_purchasing_doc.

    METHODS:
      setup,
      mock_configuration,
      mount_data,
      mount_return_table RETURNING VALUE(result) TYPE bapiret2_tab,
      mount_service_sheet RETURNING VALUE(result) TYPE REF TO /s4tax/4s_sheet,

      generate_migo FOR TESTING RAISING cx_static_check,
      change_purchase_order FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_dal_4service_sheet IMPLEMENTATION.

  METHOD setup.
    mock_dao_pack_4service ?= cl_abap_testdouble=>create( interface_dao_pack_4service ).
    mock_material_document_dal ?= cl_abap_testdouble=>create( interface_material_doc_dal ).
    mock_dao_pack_gen_data ?= cl_abap_testdouble=>create( interface_dao_pack_gen_data ).
    mock_purchasing_doc_dal ?= cl_abap_testdouble=>create( interface_purchasing_doc_dal ).

    mount_data(  ).
    mock_configuration(  ).

    cut = NEW #( dao_pack_4service = mock_dao_pack_4service
                 dao_pack_gen_data = mock_dao_pack_gen_data ).
  ENDMETHOD.

  METHOD generate_migo.
    DATA: act           TYPE bapiret2_tab.

    act = cut->/s4tax/idal_4service_sheet~generate_migo( me->service_sheet ).

    cl_abap_unit_assert=>assert_equals( exp = mount_return_table(  ) act = act ).
  ENDMETHOD.

  METHOD mock_configuration.
    DATA: header            TYPE bapi2017_gm_head_01,
          gm_code           TYPE bapi2017_gm_code,
          item_create_table TYPE tab_bapi_goodsmvt_item,
          migo_created      TYPE bapi2017_gm_head_ret,
          return            TYPE STANDARD TABLE OF bapiret2,
          poheader          TYPE bapimepoheader,
          poheaderx         TYPE bapimepoheaderx,
          poitem            TYPE bapimepoitem,
          poitemx           TYPE bapimepoitemx.

    cl_abap_testdouble=>configure_call( mock_dao_pack_4service )->returning( mock_material_document_dal )->ignore_all_parameters( ).
    mock_dao_pack_4service->material_document_dal( ).

    cl_abap_testdouble=>configure_call( mock_dao_pack_gen_data )->returning( mock_purchasing_doc_dal )->ignore_all_parameters( ).
    mock_dao_pack_gen_data->purchasing_document_dal( ).

    cl_abap_testdouble=>configure_call( mock_purchasing_doc_dal )->returning( return_table )->ignore_all_parameters( ).
    mock_purchasing_doc_dal->call_bapi_po_change( poheader  = poheader poheaderx = poheaderx
                                                  poitem    = poitem   poitemx   = poitemx ).

    migo_created-mat_doc = 'teste'.
    cl_abap_testdouble=>configure_call( mock_material_document_dal
                                      )->ignore_all_parameters(
                                      )->set_parameter(  name          = 'GOODSMVT_HEADRET'
                                                         value         = migo_created
                                      )->set_parameter( name          = 'RESULT'
                                                        value         = return_table ).
    mock_material_document_dal->call_bapi_goodsmvt_create( EXPORTING goodsmvt_header = header
                                                                     goodsmvt_code   = gm_code
                                                            CHANGING  result = return
                                                                      goodsmvt_item_table = item_create_table
                                                                      goodsmvt_headret = migo_created ).

  ENDMETHOD.

  METHOD mount_data.
    me->return_table = mount_return_table(  ).
    me->service_sheet = mount_service_sheet(  ).
  ENDMETHOD.

  METHOD mount_service_sheet.
    DATA: reporter_setting TYPE REF TO /s4tax/ireporter_settings,
          reporter         TYPE REF TO /s4tax/ireporter.

    CREATE OBJECT reporter_setting TYPE /s4tax/reporter_settings.
    reporter_setting->set_autosave( abap_false ).

    reporter = /s4tax/reporter_factory=>create( object =  /s4tax/reporter_factory=>object-s4tax
                                                subobject = /s4tax/reporter_factory=>subobject-four_service
                                                settings  = reporter_setting ).
    result = NEW #(  ).

    result->set_appointment_id( '000' ).
    result->set_start_period( '20220101' ).
    result->set_end_period( '20220110' ).
    result->set_branch_id( '123' ).
    result->set_provider_fiscal_id_number( '1234' ).
    result->set_employment_erp_code( '1234' ).
    result->set_reporter( reporter ).
  ENDMETHOD.

  METHOD mount_return_table.
    DATA: rtn TYPE bapiret2.

    rtn-id = '1234'.
    rtn-log_no = '123'.
    rtn-message = 'test return msg'.

    APPEND rtn TO result.
  ENDMETHOD.

  METHOD change_purchase_order.
    DATA: act TYPE bapiret2_tab.

    act = cut->/s4tax/idal_4service_sheet~change_purchase_order( service_sheet ).

    cl_abap_unit_assert=>assert_equals( exp = mount_return_table( ) act = act ).
  ENDMETHOD.

ENDCLASS.

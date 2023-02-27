CLASS /s4tax/dal_4service_sheet DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: /s4tax/idal_4service_sheet.

    METHODS: constructor IMPORTING dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service OPTIONAL
                                   dao_pack_gen_data TYPE REF TO /s4tax/idao_pack_gen_data OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service,
          dao_pack_gen_data TYPE REF TO /s4tax/idao_pack_gen_data.

ENDCLASS.



CLASS /s4tax/dal_4service_sheet IMPLEMENTATION.
  METHOD /s4tax/idal_4service_sheet~change_purchase_order.
    DATA: poheader           TYPE bapimepoheader,
          poheaderx          TYPE bapimepoheaderx,
          poitem             TYPE bapimepoitem,
          poitemx            TYPE bapimepoitemx,
          dal_purchasing_doc TYPE REF TO /s4tax/idal_purchasing_doc.

    poheader-po_number = service_sheet->struct-order_number.
    poheaderx-po_number = 'X'.

    poitem-po_item = service_sheet->struct-order_item.
    poitemx-po_item = service_sheet->struct-order_item.
    poitem-net_price = service_sheet->struct-approved_value.
    poitemx-net_price = 'X'.
    poitem-gr_ind = 'X'.
    poitemx-gr_ind = 'X'.
    poitem-gr_non_val = 'X'.
    poitemx-gr_non_val = 'X'.

    dal_purchasing_doc = me->dao_pack_gen_data->purchasing_document_dal(  ).

    result = dal_purchasing_doc->call_bapi_po_change( poheader  = poheader
                                                      poheaderx = poheaderx
                                                      poitem    = poitem
                                                      poitemx   = poitemx ).
  ENDMETHOD.

  METHOD /s4tax/idal_4service_sheet~generate_migo.
    DATA: header                TYPE bapi2017_gm_head_01,
          gm_code               TYPE bapi2017_gm_code,
          item_create_table     TYPE tab_bapi_goodsmvt_item,
          item                  TYPE bapi2017_gm_item_create,
          string_utils          TYPE REF TO /s4tax/string_utils,
          material_created      TYPE /s4tax/t4s_sheet-docref,
          dal_material_document TYPE REF TO /s4tax/idal_material_document,
          itmref                TYPE /s4tax/t4s_sheet-itmref,
          goodsmvt_items        TYPE /s4tax/idal_material_document=>item_show_tab,
          goodsmvt_item         TYPE bapi2017_gm_item_show.

    CREATE OBJECT string_utils.

    header-pstng_date = sy-datum.
    header-doc_date = sy-datum.
    header-ref_doc_no = string_utils->concatenate( msg1      = service_sheet->struct-order_number
                                                   msg2      = service_sheet->struct-order_item
                                                   separator = '-' ).
    gm_code = '01'.
    item-move_type = '101'.
    item-po_number = service_sheet->struct-order_number.
    item-po_item   = service_sheet->struct-order_item.
    item-no_more_gr   = 'X'.
    item-mvt_ind =  'B'.
    item-po_pr_qnt =  1.
    item-entry_qnt =  1.

    APPEND item TO item_create_table.

    dal_material_document = me->dao_pack_4service->material_document_dal(  ).

    dal_material_document->call_bapi_goodsmvt_create( EXPORTING goodsmvt_header = header goodsmvt_code       = gm_code
                                                      CHANGING  result = return goodsmvt_item_table = item_create_table
                                                      goodsmvt_headret = migo_created  ).

    material_created = migo_created-mat_doc.
    service_sheet->set_docref( material_created ).
    ENDMETHOD.

  METHOD constructor.

    me->dao_pack_4service = dao_pack_4service.
    IF me->dao_pack_4service IS NOT BOUND.
      me->dao_pack_4service = /s4tax/dao_pack_4service=>default_instance(  ).
    ENDIF.

    me->dao_pack_gen_data = dao_pack_gen_data.
    IF me->dao_pack_gen_data IS NOT BOUND.
      me->dao_pack_gen_data = /s4tax/dao_pack_gen_data=>default_instance(  ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.

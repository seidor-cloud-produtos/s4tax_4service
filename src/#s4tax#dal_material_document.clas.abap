CLASS /s4tax/dal_material_document DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS abap .

    INTERFACES /s4tax/idal_material_document .

    METHODS:
      constructor IMPORTING dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service OPTIONAL .

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service.
ENDCLASS.



CLASS /s4tax/dal_material_document IMPLEMENTATION.


  METHOD /s4tax/idal_material_document~fill_mat_doc_seg_many_mat_doc.
    DATA: dao_material_document   TYPE REF TO /s4tax/idao_material_document,
          dao_material_doc_seg    TYPE REF TO /s4tax/idao_material_doc_seg,
          material_document_table TYPE /s4tax/tmaterial_document_t,
          mblnr_range             TYPE ace_generic_range_t,
          material_doc_seg_list   TYPE /s4tax/material_document_seg_t,
          material_document       TYPE REF TO /s4tax/material_document,
          material_document_seg   TYPE REF TO /s4tax/material_document_seg,
          index                   TYPE syst-tabix.

    IF material_document_list IS INITIAL.
      RETURN.
    ENDIF.

    dao_material_document = me->dao_pack_4service->material_document(  ).
    dao_material_doc_seg = me->dao_pack_4service->material_doc_seg(  ).

    material_document_table = dao_material_document->objects_to_struct( material_document_list ).

    mblnr_range = /s4tax/range_utils=>specific_range( range = material_document_table low = 'MBLNR' ).
    material_doc_seg_list = dao_material_doc_seg->get_many_by_material( material_number_range = mblnr_range ).

    IF material_doc_seg_list IS INITIAL.
      RETURN.
    ENDIF.

    SORT material_doc_seg_list BY table_line->struct-mblnr table_line->struct-mjahr.

    LOOP AT material_document_list INTO material_document.
      READ TABLE material_doc_seg_list INTO material_document_seg WITH KEY table_line->struct-mblnr = material_document->struct-mblnr
                                              table_line->struct-mjahr = material_document->struct-mjahr.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      index = sy-tabix.

      LOOP AT material_doc_seg_list INTO material_document_seg FROM index.
        IF material_document_seg->struct-mblnr <> material_document->struct-mblnr OR material_document_seg->struct-mjahr <> material_document->struct-mjahr.
          EXIT.
        ENDIF.

        material_document->add_material_doc_segment( material_document_seg ).
      ENDLOOP.
    ENDLOOP.

    result = material_doc_seg_list.
  ENDMETHOD.


  METHOD constructor.
    me->dao_pack_4service = dao_pack_4service.
    IF me->dao_pack_4service IS NOT BOUND.
      me->dao_pack_4service = /s4tax/dao_pack_4service=>default_instance( ).
    ENDIF.
  ENDMETHOD.

  METHOD /s4tax/idal_material_document~call_bapi_goodsmvt_create.
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = goodsmvt_header
        goodsmvt_code    = goodsmvt_code
      IMPORTING
        goodsmvt_headret = goodsmvt_headret
      TABLES
        goodsmvt_item    = goodsmvt_item_table
        return           = result.
  ENDMETHOD.

ENDCLASS.

INTERFACE /s4tax/idal_material_document
  PUBLIC .


  METHODS:
    fill_mat_doc_seg_many_mat_doc IMPORTING material_document_list TYPE /s4tax/material_document_t
                                  RETURNING VALUE(result)          TYPE /s4tax/material_document_seg_t,

    call_bapi_goodsmvt_create IMPORTING goodsmvt_header     TYPE bapi2017_gm_head_01
                                        goodsmvt_code       TYPE bapi2017_gm_code
                              CHANGING  result              TYPE bapiret2_tab
                                        goodsmvt_headret    TYPE bapi2017_gm_head_ret
                                        goodsmvt_item_table TYPE tab_bapi_goodsmvt_item.
ENDINTERFACE.

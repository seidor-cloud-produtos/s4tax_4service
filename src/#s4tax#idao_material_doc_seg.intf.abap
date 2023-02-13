INTERFACE /s4tax/idao_material_doc_seg
  PUBLIC .


  METHODS:
    save IMPORTING material TYPE REF TO /s4tax/material_document_seg,
    get_many_by_material IMPORTING material_number_range TYPE ace_generic_range_t
                         RETURNING VALUE(result)         TYPE /s4tax/material_document_seg_t,
    struct_to_objects IMPORTING material_table TYPE /s4tax/tmaterial_doc_segment_t
                      RETURNING VALUE(result)  TYPE /s4tax/material_document_seg_t,
    objects_to_struct IMPORTING material_list TYPE /s4tax/material_document_seg_t
                      RETURNING VALUE(result) TYPE /s4tax/tmaterial_doc_segment_t .
ENDINTERFACE.

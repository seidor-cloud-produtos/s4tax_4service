INTERFACE /s4tax/idao_material_document
  PUBLIC .


  METHODS: save IMPORTING material_doc TYPE REF TO /s4tax/material_document,
    get_many_by_material_doc IMPORTING material_number_range TYPE ace_generic_range_t
                                       material_year         TYPE mjahr OPTIONAL
                             RETURNING VALUE(result)         TYPE /s4tax/material_document_t,
    struct_to_objects  IMPORTING material_doc_table TYPE /s4tax/tmaterial_document_t
                       RETURNING VALUE(result)      TYPE /s4tax/material_document_t,
    objects_to_struct IMPORTING material_doc_list TYPE /s4tax/material_document_t
                      RETURNING VALUE(result)     TYPE /s4tax/tmaterial_document_t .
ENDINTERFACE.

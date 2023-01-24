INTERFACE /s4tax/idao_mkpf
  PUBLIC .

  METHODS:
    save IMPORTING material_doc TYPE REF TO /s4tax/mkpf,

    get_many_by_material_doc IMPORTING material_number_range TYPE ace_generic_range_t
                                       material_year         TYPE mjahr
                             RETURNING VALUE(result)         TYPE /s4tax/mkpf_t,

    struct_to_objects IMPORTING material_doc_table TYPE /s4tax/tmkpf_t
                      RETURNING VALUE(result)  TYPE /s4tax/mkpf_t,

    objects_to_struct IMPORTING material_doc_list TYPE /s4tax/mkpf_t
                      RETURNING VALUE(result) TYPE /s4tax/tmkpf_t.

ENDINTERFACE.

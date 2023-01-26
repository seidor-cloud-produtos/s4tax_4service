INTERFACE /s4tax/idao_mseg
  PUBLIC .

  METHODS:
    save IMPORTING material TYPE REF TO /s4tax/mseg,

    get_many_by_material IMPORTING material_number_range TYPE ace_generic_range_t
                         RETURNING VALUE(result)         TYPE /s4tax/mseg_t,

    struct_to_objects IMPORTING material_table TYPE /s4tax/tmseg_t
                      RETURNING VALUE(result)  TYPE /s4tax/mseg_t,

    objects_to_struct IMPORTING material_list TYPE /s4tax/mseg_t
                      RETURNING VALUE(result) TYPE /s4tax/tmseg_t.
ENDINTERFACE.

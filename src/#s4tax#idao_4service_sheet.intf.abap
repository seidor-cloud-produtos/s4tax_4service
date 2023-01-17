INTERFACE /s4tax/idao_4service_sheet
  PUBLIC .
  METHODS:
    save IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet,

    get_all RETURNING VALUE(result)  TYPE /s4tax/4s_sheet_t,

    struct_to_objects IMPORTING service_sheet_table TYPE /s4tax/t4s_sheet_t
                      RETURNING VALUE(result)       TYPE /s4tax/4s_sheet_t,

    objects_to_struct IMPORTING service_sheet_list TYPE /s4tax/4s_sheet_t
                      RETURNING VALUE(result)      TYPE /s4tax/t4s_sheet_t.
ENDINTERFACE.

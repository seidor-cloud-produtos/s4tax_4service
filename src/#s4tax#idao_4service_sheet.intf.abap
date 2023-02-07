INTERFACE /s4tax/idao_4service_sheet
  PUBLIC .
  METHODS:
    save IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet,

    save_many IMPORTING service_sheet_list TYPE /s4tax/4s_sheet_t,

    get_all RETURNING VALUE(result)  TYPE /s4tax/4s_sheet_t,

    get_many_by_period IMPORTING initial_date  TYPE /s4tax/t4s_sheet-start_period
                                 final_date    TYPE /s4tax/t4s_sheet-end_period
                       RETURNING VALUE(result) TYPE /s4tax/4s_sheet_t,

    get_by_appointment_id IMPORTING appointment_id TYPE /s4tax/t4s_sheet-appointment_id
                          RETURNING VALUE(result)  TYPE REF TO /s4tax/4s_sheet,

    get_many_for_monitor IMPORTING initial_date    TYPE /s4tax/t4s_sheet-start_period
                                   final_date      TYPE /s4tax/t4s_sheet-end_period
                                   fiscal_id_range TYPE ace_generic_range_t
                                   branch_range    TYPE ace_generic_range_t
                         RETURNING VALUE(result)   TYPE /s4tax/4s_sheet_t,

    struct_to_objects IMPORTING service_sheet_table TYPE /s4tax/t4s_sheet_t
                      RETURNING VALUE(result)       TYPE /s4tax/4s_sheet_t,

    objects_to_struct IMPORTING service_sheet_list TYPE /s4tax/4s_sheet_t
                      RETURNING VALUE(result)      TYPE /s4tax/t4s_sheet_t.
ENDINTERFACE.

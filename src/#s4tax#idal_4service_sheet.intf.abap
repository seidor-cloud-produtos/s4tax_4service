INTERFACE /s4tax/idal_4service_sheet
  PUBLIC .
  METHODS:
    change_purchase_order IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
                          RETURNING VALUE(result) TYPE bapiret2_tab,

    generate_migo IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
                  RETURNING VALUE(result) TYPE bapiret2_tab.

ENDINTERFACE.

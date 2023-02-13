CLASS /s4tax/4service_constants DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF timesheet_status,
        in_process TYPE char2 VALUE '01',
        finished   TYPE char2 VALUE '02',
        error      TYPE char2 VALUE '03',
      END OF timesheet_status,

      BEGIN OF business_status,
        order_edit_success  TYPE char2 VALUE '01',
        order_edit_error    TYPE char2 VALUE '02',
        create_migo_success TYPE char2 VALUE '03',
        create_migo_error   TYPE char2 VALUE '04',
        finished            TYPE char2 VALUE '05',
      END OF business_status,

      BEGIN OF params,
        initial_date_commit TYPE string VALUE 'initial_date_commit',
        final_date_commit   TYPE string VALUE 'final_date_commit',
      END OF params,

      BEGIN OF source,
        pedido_compra TYPE char2 VALUE '01',
        migo          TYPE char2 VALUE '02',
      END OF source.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/4service_constants IMPLEMENTATION.
ENDCLASS.

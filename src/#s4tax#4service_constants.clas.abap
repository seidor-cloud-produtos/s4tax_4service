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
      END OF timesheet_status.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/4service_constants IMPLEMENTATION.
ENDCLASS.

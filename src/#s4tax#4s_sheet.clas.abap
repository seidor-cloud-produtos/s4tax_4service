CLASS /s4tax/4s_sheet DEFINITION
  PUBLIC
  INHERITING FROM /s4tax/model_t4s_sheet
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: constructor IMPORTING iw_struct TYPE /s4tax/t4s_sheet OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/4s_sheet IMPLEMENTATION.
  METHOD constructor.

    super->constructor( ).

    IF iw_struct IS INITIAL.
      RETURN.
    ENDIF.

    me->set_start_period( iw_struct-start_period ).
    me->set_end_period( iw_struct-end_period ).
    me->set_branch_id( iw_struct-branch_id ).
    me->set_provider_fiscal_id_number( iw_struct-provider_fiscal_id_number ).
    me->set_employment_erp_code( iw_struct-employment_erp_code ).
    me->set_appointment_id( iw_struct-appointment_id ).
    me->set_approved_value( iw_struct-approved_value ).
    me->set_status( iw_struct-status ).
  ENDMETHOD.

ENDCLASS.

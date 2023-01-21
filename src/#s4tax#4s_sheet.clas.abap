CLASS /s4tax/4s_sheet DEFINITION
  PUBLIC
  INHERITING FROM /s4tax/model_t4s_sheet
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA:
      reporter TYPE REF TO /s4tax/ireporter READ-ONLY.

    METHODS:
      constructor IMPORTING iw_struct TYPE /s4tax/t4s_sheet OPTIONAL,

      get_reporter RETURNING VALUE(result) TYPE REF TO /s4tax/ireporter,
      set_reporter IMPORTING reporter TYPE REF TO /s4tax/ireporter.

  PROTECTED SECTION.
    METHODS:
      open_by_id IMPORTING log_number    TYPE sysuuid_22
                 RETURNING VALUE(result) TYPE REF TO /s4tax/ireporter,
      create_reporter RETURNING VALUE(result) TYPE REF TO /s4tax/ireporter.

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
    me->set_update_at( iw_struct-update_at ).
    me->set_update_name( iw_struct-update_name ).
    me->set_credat( iw_struct-credat ).
    me->set_log_number( iw_struct-log_number ).
  ENDMETHOD.

  METHOD open_by_id.
    result = /s4tax/reporter_factory=>open_by_id( object = /s4tax/reporter_factory=>object-s4tax
                                                  subobject = /s4tax/reporter_factory=>subobject-four_service
                                                  log_id = log_number ).
  ENDMETHOD.

  METHOD get_reporter.
    DATA: log_number TYPE sysuuid_22,
          msg        TYPE string.

    IF me->reporter IS BOUND.
      result = me->reporter.
      RETURN.
    ENDIF.

    IF me->struct-log_number IS NOT INITIAL.
      log_number = me->struct-log_number.
      me->reporter = open_by_id( log_number ).
      result = me->reporter.
      RETURN.
    ENDIF.

    me->reporter = create_reporter( ).

    IF me->reporter IS NOT BOUND.
      RETURN.
    ENDIF.

    MESSAGE s002(/s4tax/4service) WITH me->struct-update_at me->struct-provider_fiscal_id_number me->struct-appointment_id INTO msg.
    me->reporter->info( msg ).
    me->set_log_number( me->reporter->db_number ).
    result = me->reporter.
  ENDMETHOD.

  METHOD set_reporter.
    me->reporter = reporter.
  ENDMETHOD.

  METHOD create_reporter.
    result = /s4tax/reporter_factory=>create( object =  /s4tax/reporter_factory=>object-s4tax
                                                          subobject = /s4tax/reporter_factory=>subobject-four_service  ).
  ENDMETHOD.

ENDCLASS.

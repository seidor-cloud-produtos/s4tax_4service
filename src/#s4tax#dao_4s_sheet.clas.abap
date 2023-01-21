CLASS /s4tax/dao_4s_sheet DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS: abap.
    INTERFACES /s4tax/idao_4service_sheet.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/dao_4s_sheet IMPLEMENTATION.

  METHOD /s4tax/idao_4service_sheet~get_all.
    DATA: service_sheet_table TYPE /s4tax/t4s_sheet_t.

    SELECT * FROM /s4tax/t4s_sheet INTO TABLE service_sheet_table.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    result = me->/s4tax/idao_4service_sheet~struct_to_objects( service_sheet_table ).
  ENDMETHOD.

  METHOD /s4tax/idao_4service_sheet~save.
    DATA: t4s_sheet TYPE /s4tax/t4s_sheet.

    t4s_sheet-start_period = service_sheet->get_start_period( ).
    t4s_sheet-end_period = service_sheet->get_end_period( ).
    t4s_sheet-branch_id = service_sheet->get_branch_id( ).
    t4s_sheet-provider_fiscal_id_number = service_sheet->get_provider_fiscal_id_number( ).
    t4s_sheet-employment_erp_code = service_sheet->get_employment_erp_code( ).
    t4s_sheet-appointment_id = service_sheet->get_appointment_id( ).
    t4s_sheet-approved_value = service_sheet->get_approved_value( ).
    t4s_sheet-status = service_sheet->get_status( ).
    t4s_sheet-credat = service_sheet->get_credat(  ).
    t4s_sheet-log_number = service_sheet->get_log_number(  ).
    t4s_sheet-update_at = service_sheet->get_update_at( ).
    t4s_sheet-update_name = service_sheet->get_update_name(  ).

    MODIFY /s4tax/t4s_sheet FROM t4s_sheet.
  ENDMETHOD.

  METHOD /s4tax/idao_4service_sheet~objects_to_struct.
    DATA: service_sheet TYPE REF TO /s4tax/4s_sheet.

    IF service_sheet_list IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT service_sheet_list INTO service_sheet.
      IF service_sheet IS NOT BOUND.
        CONTINUE.
      ENDIF.
      APPEND service_sheet->struct TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD /s4tax/idao_4service_sheet~struct_to_objects.
    DATA: t4s_sheet     TYPE /s4tax/t4s_sheet,
          service_sheet TYPE REF TO /s4tax/4s_sheet.

    IF service_sheet_table IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT service_sheet_table INTO t4s_sheet.
      CREATE OBJECT service_sheet EXPORTING iw_struct = t4s_sheet.
      APPEND service_sheet TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD /s4tax/idao_4service_sheet~save_many.
    DATA: service_sheet_table TYPE /s4tax/t4s_sheet_t.

    IF service_sheet_list IS INITIAL.
      RETURN.
    ENDIF.

    service_sheet_table = me->/s4tax/idao_4service_sheet~objects_to_struct( service_sheet_list ).

    MODIFY /s4tax/t4s_sheet FROM TABLE service_sheet_table.
  ENDMETHOD.

  METHOD /s4tax/idao_4service_sheet~get_many_for_monitor.
    DATA: service_sheet_table TYPE /s4tax/t4s_sheet_t.

    SELECT * FROM /s4tax/t4s_sheet
    INTO TABLE service_sheet_table
    WHERE provider_fiscal_id_number IN fiscal_id_range
    AND start_period >= initial_date AND end_period <= final_date
    AND branch_id IN branch_range.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    result = me->/s4tax/idao_4service_sheet~struct_to_objects( service_sheet_table ).
  ENDMETHOD.

ENDCLASS.

CLASS /s4tax/model_t4s_sheet DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: struct TYPE /s4tax/t4s_sheet READ-ONLY.
    METHODS:
      get_start_period RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-start_period,
      set_start_period IMPORTING iv_start_period TYPE /s4tax/t4s_sheet-start_period,

      get_end_period RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-end_period,
      set_end_period IMPORTING iv_end_period TYPE /s4tax/t4s_sheet-end_period,

      get_branch_id RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-branch_id,
      set_branch_id IMPORTING iv_branch_id TYPE /s4tax/t4s_sheet-branch_id,

      get_provider_fiscal_id_number RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-provider_fiscal_id_number,
      set_provider_fiscal_id_number  IMPORTING iv_provider_fiscal_id_number TYPE /s4tax/t4s_sheet-provider_fiscal_id_number,

      get_employment_erp_code RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-employment_erp_code,
      set_employment_erp_code IMPORTING iv_employment_erp_code TYPE /s4tax/t4s_sheet-employment_erp_code,

      get_appointment_id RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-appointment_id,
      set_appointment_id IMPORTING iv_appointment_id TYPE /s4tax/t4s_sheet-appointment_id,

      get_approved_value RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-approved_value,
      set_approved_value IMPORTING iv_approved_value TYPE /s4tax/t4s_sheet-approved_value,

      get_status RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-status,
      set_status IMPORTING iv_status TYPE /s4tax/t4s_sheet-status,

      get_log_number RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-log_number,
      set_log_number IMPORTING iv_log_number TYPE /s4tax/t4s_sheet-log_number,

      get_update_at RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-update_at,
      set_update_at IMPORTING iv_update_at TYPE /s4tax/t4s_sheet-update_at,

      get_update_name RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-update_name,
      set_update_name IMPORTING iv_update_name TYPE /s4tax/t4s_sheet-update_name,

      get_credat RETURNING VALUE(result) TYPE /s4tax/t4s_sheet-credat,
      set_credat IMPORTING iv_credat TYPE /s4tax/t4s_sheet-credat.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/model_t4s_sheet IMPLEMENTATION.
  METHOD get_start_period.
    result = me->struct-start_period.
  ENDMETHOD.


  METHOD set_start_period.
    me->struct-start_period = iv_start_period.
  ENDMETHOD.


  METHOD get_end_period.
    result = me->struct-end_period.
  ENDMETHOD.


  METHOD set_end_period.
    me->struct-end_period = iv_end_period.
  ENDMETHOD.


  METHOD get_branch_id.
    result = me->struct-branch_id.
  ENDMETHOD.


  METHOD set_branch_id.
    me->struct-branch_id = iv_branch_id.
  ENDMETHOD.


  METHOD get_provider_fiscal_id_number.
    result = me->struct-provider_fiscal_id_number.
  ENDMETHOD.


  METHOD set_provider_fiscal_id_number.
    me->struct-provider_fiscal_id_number = iv_provider_fiscal_id_number.
  ENDMETHOD.


  METHOD get_employment_erp_code.
    result = me->struct-employment_erp_code.
  ENDMETHOD.


  METHOD set_employment_erp_code.
    me->struct-employment_erp_code = iv_employment_erp_code.
  ENDMETHOD.


  METHOD get_appointment_id.
    result = me->struct-appointment_id.
  ENDMETHOD.


  METHOD set_appointment_id.
    me->struct-appointment_id = iv_appointment_id.
  ENDMETHOD.


  METHOD get_approved_value.
    result = me->struct-approved_value.
  ENDMETHOD.


  METHOD set_approved_value.
    me->struct-approved_value = iv_approved_value.
  ENDMETHOD.


  METHOD get_status.
    result = me->struct-status.
  ENDMETHOD.


  METHOD set_status.
    me->struct-status = iv_status.
  ENDMETHOD.
  METHOD get_log_number.
    result = me->struct-log_number.
  ENDMETHOD.

  METHOD get_update_at.
    result = me->struct-update_at.
  ENDMETHOD.

  METHOD get_update_name.
    result = me->struct-update_name.
  ENDMETHOD.

  METHOD set_log_number.
    me->struct-log_number = iv_log_number.
  ENDMETHOD.

  METHOD set_update_at.
    me->struct-update_at = iv_update_at.
  ENDMETHOD.

  METHOD set_update_name.
    me->struct-update_name = iv_update_name.
  ENDMETHOD.

  METHOD get_credat.
    result = me->struct-credat.
  ENDMETHOD.

  METHOD set_credat.
    me->struct-credat = iv_credat.
  ENDMETHOD.

ENDCLASS.

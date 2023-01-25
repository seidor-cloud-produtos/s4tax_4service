*&---------------------------------------------------------------------*
*& Report /s4tax/4service_monitor
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /s4tax/4service_monitor.

TYPE-POOLS: abap.

CLASS service_alv DEFINITION.

  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING container TYPE REF TO cl_gui_container,
      refresh_fields IMPORTING data TYPE REF TO /s4tax/s_appointments_4s_alv OPTIONAL,
      set_data_table IMPORTING data_table TYPE /s4tax/s_appointments_4s_alv_t,
      display_alv,
      update_view.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: alv              TYPE REF TO cl_gui_alv_grid,
          appointments_alv TYPE /s4tax/s_appointments_4s_alv_t,
          layout           TYPE lvc_s_layo,
          ddic_utils       TYPE REF TO /s4tax/ddic_utils.
    METHODS:
      get_fieldcat RETURNING VALUE(result) TYPE lvc_t_fcat,

      set_exclude_buttons RETURNING VALUE(result) TYPE ui_functions,

      display_log IMPORTING data TYPE REF TO /s4tax/s_appointments_4s_alv,

      on_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING es_row_no e_column_id e_row_id.

ENDCLASS.

CLASS service_alv IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT ddic_utils.
    CREATE OBJECT me->alv EXPORTING i_parent = container.
    me->display_alv(  ).
  ENDMETHOD.


  METHOD refresh_fields.
    REFRESH me->appointments_alv.
  ENDMETHOD.

    METHOD on_hotspot_click.
    DATA: data TYPE REF TO /s4tax/s_appointments_4s_alv.

    READ TABLE me->appointments_alv REFERENCE INTO data INDEX e_row_id-index.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    CASE e_column_id-fieldname.
      WHEN 'STATUS'.
        me->display_log( data ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_log.

    IF data IS NOT BOUND.
      RETURN.
    ENDIF.

    IF data->reporter IS NOT BOUND.
      RETURN.
    ENDIF.

    data->reporter->fullscreen( ).

  ENDMETHOD.


  METHOD get_fieldcat.

    DATA: lr_field TYPE REF TO lvc_s_fcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = '/S4TAX/S_APPOINTMENTS_4S_ALV'
      CHANGING
        ct_fieldcat            = result
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.

    ENDIF.

    LOOP AT result REFERENCE INTO lr_field.

      CASE lr_field->fieldname.
        WHEN 'APPOINTMENT_ID'.
          lr_field->scrtext_s = 'Id Apont.'.
          lr_field->scrtext_m = 'Id Apont.'.
          lr_field->scrtext_l = 'Id do Apontamento'.
        WHEN 'START_PERIOD'.
          lr_field->scrtext_s = 'Início do período'.
          lr_field->scrtext_m = 'Início do período'.
          lr_field->scrtext_l = 'Início do período'.
        WHEN 'END_PERIOD'.
          lr_field->scrtext_s = 'Final do período'.
          lr_field->scrtext_m = 'Final do período'.
          lr_field->scrtext_l = 'Final do período'.
        WHEN 'BRANCH_ID'.
          lr_field->scrtext_s = 'Id filial'.
          lr_field->scrtext_m = 'Id filial'.
          lr_field->scrtext_l = 'Id filial'.

        WHEN 'PROVIDER_FISCAL_ID_NUMBER'.
          lr_field->scrtext_s = 'CNPJ da empresa'.
          lr_field->scrtext_m = 'CNPJ da empresa'.
          lr_field->scrtext_l = 'CNPJ da empresa'.

        WHEN 'EMPLOYMENT_ERP_CODE'.
          lr_field->scrtext_s = 'Código ERP'.
          lr_field->scrtext_m = 'Código ERP'.
          lr_field->scrtext_l = 'Código ERP'.

        WHEN 'APPROVED_VALUE'.
          lr_field->scrtext_s = 'Valor a receber'.
          lr_field->scrtext_m = 'Valor a receber'.
          lr_field->scrtext_l = 'Valor a receber'.

        WHEN 'CREDAT'.
          lr_field->scrtext_s = 'Data de criação'.
          lr_field->scrtext_m = 'Data de criação'.
          lr_field->scrtext_l = 'Data de criação'.

        WHEN 'UPDATE_AT'.
          lr_field->scrtext_s = 'Data de at.'.
          lr_field->scrtext_m = 'Data de atualização'.
          lr_field->scrtext_l = 'Data de atualização'.

        WHEN 'UPDATE_NAME'.
          lr_field->scrtext_s = 'Usuário'.
          lr_field->scrtext_m = 'Usuário'.
          lr_field->scrtext_l = 'Usuário'.

        WHEN 'STATUS'.
          lr_field->hotspot = abap_true.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

  METHOD display_alv.
    DATA: fcat            TYPE lvc_t_fcat,
          variant         TYPE disvariant,
          sy              TYPE syst,
          exclude_buttons TYPE ui_functions.

    fcat = me->get_fieldcat( ).

    layout-zebra         = abap_true.
    layout-sel_mode      = 'A'.
    layout-col_opt       = abap_true.
    layout-cwidth_opt    = abap_true.
    variant-report  = sy-cprog.

    exclude_buttons = me->set_exclude_buttons( ).

    CALL METHOD me->alv->set_table_for_first_display
      EXPORTING
        is_variant                    = variant
        i_save                        = abap_true
        is_layout                     = layout
        it_toolbar_excluding          = exclude_buttons
      CHANGING
        it_outtab                     = me->appointments_alv
        it_fieldcatalog               = fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    SET HANDLER: me->on_hotspot_click      FOR me->alv.

  ENDMETHOD.

  METHOD set_exclude_buttons.
    APPEND cl_gui_alv_grid=>mc_mb_sum        TO result.
    APPEND cl_gui_alv_grid=>mc_mb_subtot     TO result.
    APPEND cl_gui_alv_grid=>mc_fc_graph      TO result.
    APPEND cl_gui_alv_grid=>mc_fc_info       TO result.
    APPEND cl_gui_alv_grid=>mc_fc_print_back TO result.
    APPEND cl_gui_alv_grid=>mc_fc_call_chain TO result.
    APPEND cl_gui_alv_grid=>mc_mb_view       TO result.
    APPEND cl_gui_alv_grid=>mc_mb_export     TO result.
  ENDMETHOD.


  METHOD update_view.
    DATA: lw_stbl TYPE lvc_s_stbl.

    lw_stbl-row = 'X'.
    lw_stbl-col = 'X'.

    CALL METHOD me->alv->set_frontend_layout EXPORTING is_layout = layout.
    alv->refresh_table_display(
     EXPORTING
       is_stable      = lw_stbl
       i_soft_refresh = ' '
     EXCEPTIONS
       finished       = 1
       OTHERS         = 2
   ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD set_data_table.
    me->appointments_alv = data_table.
  ENDMETHOD.



ENDCLASS.

CLASS main DEFINITION.

  PUBLIC SECTION.
    METHODS: constructor IMPORTING date_range        TYPE ace_generic_range_t
                                   fiscal_id_range   TYPE ace_generic_range_t
                                   branch_range      TYPE ace_generic_range_t
                                   dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service OPTIONAL,
      run,
      pbo,
      pai.

  PROTECTED SECTION.
    DATA: dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service.

  PRIVATE SECTION.
    DATA:
      service_alv        TYPE REF TO service_alv,
      main_alv_table     TYPE /s4tax/s_appointments_4s_alv_t,
      service_container  TYPE REF TO cl_gui_container,
      ddic_utils         TYPE REF TO /s4tax/ddic_utils,
      initial_date       TYPE datum,
      final_date         TYPE datum,
      splitter_container TYPE REF TO cl_gui_splitter_container,
      date_range         TYPE ace_generic_range_t,
      fiscal_id_range    TYPE ace_generic_range_t,
      branch_range       TYPE ace_generic_range_t.

    METHODS:
      create_alv,
      select_range_data RETURNING VALUE(result) TYPE /s4tax/4s_sheet_t,
      mount_main_alv,
      mount_credat_range IMPORTING date_range TYPE ace_generic_range_t,
      set_screen_details,
      refresh,
      set_alv_data.


ENDCLASS.


CLASS main IMPLEMENTATION.

  METHOD constructor.
    me->date_range = date_range.
    me->fiscal_id_range = fiscal_id_range.
    me->branch_range = branch_range.
    me->mount_credat_range( date_range = date_range ).
    me->dao_pack_4service = dao_pack_4service.

    IF me->dao_pack_4service IS NOT BOUND.
      me->dao_pack_4service = /s4tax/dao_pack_4service=>default_instance( ).
    ENDIF.

    CREATE OBJECT ddic_utils.
  ENDMETHOD.

  METHOD run.

    me->mount_main_alv( ).
    CALL SCREEN 9000.
  ENDMETHOD.

  METHOD select_range_data.
    DATA: service_sheet_list TYPE /s4tax/4s_sheet_t,
          dao_4service_sheet TYPE REF TO /s4tax/idao_4service_sheet.

    dao_4service_sheet = dao_pack_4service->four_service_sheet( ).


    service_sheet_list = dao_4service_sheet->get_many_for_monitor( initial_date = initial_date
                                                                   final_date = final_date
                                                                   fiscal_id_range = me->fiscal_id_range
                                                                   branch_range    = me->branch_range
                                                                 ).

    result = service_sheet_list.
  ENDMETHOD.

  METHOD create_alv.
    IF me->service_alv IS BOUND.
      RETURN.
    ENDIF.

    CREATE OBJECT splitter_container
      EXPORTING
        align             = 15
        parent            = cl_gui_container=>default_screen
        rows              = 2
        columns           = 1
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    splitter_container->set_border( border = cl_gui_cfw=>false ).
    splitter_container->set_row_height( id = 1 height  = 60 ).

    service_container  =  splitter_container->get_container( row = 1 column = 1 ).

    CREATE OBJECT service_alv EXPORTING container = service_container.

    me->set_alv_data( ).
  ENDMETHOD.

  METHOD mount_main_alv.
    DATA: service_sheet       TYPE REF TO /s4tax/4s_sheet,
          alv_line            TYPE /s4tax/s_appointments_4s_alv,
          service_sheet_table TYPE /s4tax/4s_sheet_t,
          date                TYPE REF TO /s4tax/date.

    service_sheet_table = me->select_range_data(  ).

    LOOP AT service_sheet_table INTO service_sheet.
      alv_line-appointment_id = service_sheet->get_appointment_id(  ).
      alv_line-approved_value = service_sheet->get_approved_value(  ).
      alv_line-branch_id = service_sheet->get_branch_id(  ).
      alv_line-employment_erp_code = service_sheet->get_employment_erp_code(  ).
      alv_line-end_period = service_sheet->get_end_period(  ).
      alv_line-provider_fiscal_id_number = service_sheet->get_provider_fiscal_id_number(  ).
      alv_line-start_period = service_sheet->get_start_period(  ).
      alv_line-update_at = service_sheet->get_update_at(  ).
      alv_line-update_name = service_sheet->get_update_name(  ).
      alv_line-reporter = service_sheet->get_reporter(  ).
      alv_line-credat = service_sheet->get_credat(  ).

      CREATE OBJECT date.
      IF alv_line-credat IS NOT INITIAL.
        date->create_by_timestamp( alv_line-credat ).
        alv_line-credat = date->to_usual_date_format(  ).
      ENDIF.

      IF alv_line-update_at IS NOT INITIAL.
        date->create_by_timestamp( alv_line-update_at ).
        alv_line-update_at = date->to_usual_date_format(  ).
      ENDIF.

      CASE service_sheet->struct-status.
        WHEN /s4tax/4service_constants=>timesheet_status-in_process.
          alv_line-status = ddic_utils->get_tooltip_icon( icon_name = icon_activity text = TEXT-000 ).
        WHEN /s4tax/4service_constants=>timesheet_status-finished.
          alv_line-status = ddic_utils->get_tooltip_icon( icon_name = icon_led_green text = TEXT-001 ).
        WHEN /s4tax/4service_constants=>timesheet_status-error.
          alv_line-status = ddic_utils->get_tooltip_icon( icon_name = icon_led_red text = TEXT-002 ).
      ENDCASE.

      APPEND alv_line TO main_alv_table.
    ENDLOOP.
  ENDMETHOD.

  METHOD pai.
    CASE sy-ucomm.
      WHEN 'BACK'.
        LEAVE TO SCREEN 0.

      WHEN 'EXIT' OR 'CANCEL'.
        LEAVE PROGRAM.

      WHEN 'REFRESH'.
        me->refresh(  ).
    ENDCASE.
  ENDMETHOD.

  METHOD refresh.
    me->service_alv->refresh_fields( ).
    REFRESH me->main_alv_table.
    me->mount_main_alv( ).
    me->set_alv_data( ).
    me->service_alv->update_view( ).
  ENDMETHOD.

  METHOD pbo.
    me->create_alv( ).
    me->set_screen_details( ).
    me->service_alv->update_view(  ).
    me->service_alv->display_alv(  ).
  ENDMETHOD.


  METHOD set_alv_data.
    me->service_alv->set_data_table( me->main_alv_table ).
  ENDMETHOD.

  METHOD set_screen_details.
    DATA found TYPE i.
    found = lines( me->main_alv_table ).
    SET TITLEBAR 'T9000' WITH TEXT-003 found TEXT-004.
    SET PF-STATUS 'S9000'.
  ENDMETHOD.

  METHOD mount_credat_range.

    DATA: target_date TYPE ace_generic_range.

    READ TABLE date_range INTO target_date INDEX 1.

    IF target_date-high EQ '00000000'.
      target_date-high = target_date-low.
    ENDIF.

    initial_date = target_date-low.
    final_date = target_date-high.

  ENDMETHOD.

ENDCLASS.

DATA: monitor            TYPE REF TO main,
      fiscal_id_range    TYPE ace_generic_range_t,
      date_range         TYPE ace_generic_range_t,
      branch_id_range    TYPE ace_generic_range_t,
      t4s_sheet          TYPE /s4tax/t4s_sheet,
      first_day_of_month TYPE sy-datum,
      last_day_of_month  TYPE sy-datum.


SELECT-OPTIONS: s_fiscal FOR t4s_sheet-provider_fiscal_id_number,
                s_branch FOR t4s_sheet-branch_id,
                s_date FOR sy-datum NO-EXTENSION OBLIGATORY.

START-OF-SELECTION.

  fiscal_id_range = /s4tax/range_utils=>generic_range( range = s_fiscal[] ).
  branch_id_range  = /s4tax/range_utils=>generic_range( range = s_branch[] ).
  date_range    = /s4tax/range_utils=>generic_range( range = s_date[] ).

  CREATE OBJECT monitor
    EXPORTING
      date_range      = date_range
      fiscal_id_range = fiscal_id_range
      branch_range    = branch_id_range.

  monitor->run( ).

INITIALIZATION.

  CONCATENATE sy-datum+0(4) sy-datum+4(2) '01' INTO first_day_of_month.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = sy-datum
    IMPORTING
      last_day_of_month = last_day_of_month
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  s_date-low = first_day_of_month.
  s_date-high = last_day_of_month.
  s_date-sign = 'I'.
  s_date-option = 'EQ'.

  APPEND s_date.

  INCLUDE /s4tax/4service_monitor_sero01.

  INCLUDE /s4tax/4service_monitor_seri01.

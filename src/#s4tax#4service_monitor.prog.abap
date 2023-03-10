*&---------------------------------------------------------------------*
*& Report /s4tax/4service_monitor
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /s4tax/4service_monitor.

TYPE-POOLS: abap.

CLASS service_alv DEFINITION.

  PUBLIC SECTION.

    TYPE-POOLS: abap.

    CONSTANTS:
      BEGIN OF c_okcode,
        modificar_pedido TYPE sy-ucomm VALUE 'MODIFY',
        gerar_migo       TYPE sy-ucomm VALUE 'MIGO',
        integrar         TYPE sy-ucomm VALUE 'INTEGRATE',
      END OF c_okcode.

    METHODS:
      constructor IMPORTING container TYPE REF TO cl_gui_container,
      refresh_fields IMPORTING data TYPE REF TO /s4tax/s_appointments_4s_alv OPTIONAL,
      set_data_table IMPORTING data_table TYPE /s4tax/s_appointments_4s_alv_t,
      display_alv,
      update_view.

  PROTECTED SECTION.
    METHODS:
      change_purchase_order IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
                            RETURNING VALUE(result) TYPE abap_bool,

      generate_migo IMPORTING service_sheet TYPE REF TO /s4tax/4s_sheet
                    RETURNING VALUE(result) TYPE abap_bool,

      generate_migo_alv IMPORTING selected_lines TYPE lvc_t_row,

      change_purchase_order_alv IMPORTING selected_lines TYPE lvc_t_row,

      call_bapi_transaction_commit,

      call_bapi_transaction_rollback,

      call_bapi_goodsmvt_create IMPORTING goodsmvt_header     TYPE bapi2017_gm_head_01
                                          goodsmvt_code       TYPE bapi2017_gm_code
                                CHANGING  result              TYPE bapiret2_tab
                                          goodsmvt_headret    TYPE bapi2017_gm_head_ret
                                          goodsmvt_item_table TYPE tab_bapi_goodsmvt_item,

      call_bapi_po_change IMPORTING poheader  TYPE bapimepoheader
                                    poheaderx TYPE bapimepoheaderx
                                    poitem    TYPE bapimepoitem
                                    poitemx   TYPE bapimepoitemx
                          CHANGING  result    TYPE bapiret2_tab,

      log_bapi_return IMPORTING bapi_return   TYPE bapiret2_tab
                                reporter      TYPE REF TO /s4tax/ireporter
                      RETURNING VALUE(result) TYPE abap_bool.


  PRIVATE SECTION.
    DATA: alv              TYPE REF TO cl_gui_alv_grid,
          appointments_alv TYPE /s4tax/s_appointments_4s_alv_t,
          layout           TYPE lvc_s_layo,
          ddic_utils       TYPE REF TO /s4tax/ddic_utils,
          reporter         TYPE REF TO /s4tax/ireporter.


    METHODS:
      get_fieldcat RETURNING VALUE(result) TYPE lvc_t_fcat,

      get_selected_lines RETURNING VALUE(result) TYPE lvc_t_row,

      set_exclude_buttons RETURNING VALUE(result) TYPE ui_functions,

      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      display_log IMPORTING data TYPE REF TO /s4tax/s_appointments_4s_alv,

      on_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING es_row_no e_column_id e_row_id,

      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      create_ref_doc_supp_portal IMPORTING sheet         TYPE REF TO /s4tax/4s_sheet
                                 RETURNING VALUE(result) TYPE REF TO /s4tax/supp_doc_reference.

ENDCLASS.

CLASS service_alv IMPLEMENTATION.
  METHOD constructor.
    DATA: settings        TYPE REF TO /s4tax/reporter_settings.

    CREATE OBJECT settings.
    settings->/s4tax/ireporter_settings~set_autosave( i_auto_save = abap_false ).
    reporter = /s4tax/reporter_factory=>create( object = /s4tax/reporter_factory=>object-s4tax
                                                subobject = /s4tax/reporter_factory=>subobject-four_service ).

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
      WHEN 'STATUS' OR 'STATUS_BUSINESS'.
        me->display_log( data ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_log.

    IF data IS NOT BOUND.
      RETURN.
    ENDIF.

    IF data->reporter IS NOT BOUND.
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
          lr_field->scrtext_s = 'In??cio do per??odo'.
          lr_field->scrtext_m = 'In??cio do per??odo'.
          lr_field->scrtext_l = 'In??cio do per??odo'.
        WHEN 'END_PERIOD'.
          lr_field->scrtext_s = 'Final do per??odo'.
          lr_field->scrtext_m = 'Final do per??odo'.
          lr_field->scrtext_l = 'Final do per??odo'.
        WHEN 'BRANCH_ID'.
          lr_field->scrtext_s = 'Id filial'.
          lr_field->scrtext_m = 'Id filial'.
          lr_field->scrtext_l = 'Id filial'.

        WHEN 'PROVIDER_FISCAL_ID_NUMBER'.
          lr_field->scrtext_s = 'CNPJ da empresa'.
          lr_field->scrtext_m = 'CNPJ da empresa'.
          lr_field->scrtext_l = 'CNPJ da empresa'.

        WHEN 'EMPLOYMENT_ERP_CODE'.
          lr_field->scrtext_s = 'C??digo ERP'.
          lr_field->scrtext_m = 'C??digo ERP'.
          lr_field->scrtext_l = 'C??digo ERP'.

        WHEN 'APPROVED_VALUE'.
          lr_field->scrtext_s = 'Valor a receber'.
          lr_field->scrtext_m = 'Valor a receber'.
          lr_field->scrtext_l = 'Valor a receber'.

        WHEN 'CREDAT'.
          lr_field->scrtext_s = 'Data de cria????o'.
          lr_field->scrtext_m = 'Data de cria????o'.
          lr_field->scrtext_l = 'Data de cria????o'.

        WHEN 'UPDATE_AT'.
          lr_field->scrtext_s = 'Data de at.'.
          lr_field->scrtext_m = 'Data de atualiza????o'.
          lr_field->scrtext_l = 'Data de atualiza????o'.

        WHEN 'UPDATE_NAME'.
          lr_field->scrtext_s = 'Usu??rio'.
          lr_field->scrtext_m = 'Usu??rio'.
          lr_field->scrtext_l = 'Usu??rio'.

        WHEN 'STATUS'.
          lr_field->scrtext_s = 'Integra????o'.
          lr_field->scrtext_m = 'Integra????o'.
          lr_field->scrtext_l = 'Status de Integra????o'.
          lr_field->hotspot = abap_true.

        WHEN 'STATUS_BUSINESS'.
          lr_field->scrtext_s = 'Status Neg.'.
          lr_field->scrtext_m = 'Status Neg.'.
          lr_field->scrtext_l = 'Status Neg??cio'.
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

    SET HANDLER: me->handle_toolbar        FOR me->alv,
                 me->on_hotspot_click      FOR me->alv,
                 me->handle_user_command   FOR me->alv.

  ENDMETHOD.

  METHOD handle_toolbar.
    DATA: toolbar TYPE stb_button.

    toolbar-function  = c_okcode-modificar_pedido.
    toolbar-icon      = icon_change_text.
    toolbar-text      = TEXT-006.
    toolbar-quickinfo = TEXT-006.
    APPEND toolbar TO e_object->mt_toolbar.

    toolbar-function  = c_okcode-gerar_migo.
    toolbar-icon      = icon_new_task.
    toolbar-text      = TEXT-007.
    toolbar-quickinfo = TEXT-007.
    APPEND toolbar TO e_object->mt_toolbar.

    toolbar-function  = c_okcode-integrar.
    toolbar-icon      = icon_system_play.
    toolbar-text      = TEXT-008.
    toolbar-quickinfo = TEXT-008.
    APPEND toolbar TO e_object->mt_toolbar.
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



  METHOD get_selected_lines.
    CALL METHOD me->alv->get_selected_rows IMPORTING et_index_rows = result.
  ENDMETHOD.

  METHOD handle_user_command.
    DATA: selected_lines TYPE lvc_t_row,
          require        TYPE abap_bool,
          has_errors     TYPE abap_bool,
          has_warnings   TYPE abap_bool.

    selected_lines = get_selected_lines( ).

    IF lines( selected_lines ) EQ 0 AND require = abap_true.
      MESSAGE TEXT-005 TYPE 'S' DISPLAY LIKE 'W'.
      RETURN.
    ENDIF.

    CASE e_ucomm.
      WHEN c_okcode-gerar_migo.
        me->generate_migo_alv( selected_lines ).

      WHEN c_okcode-modificar_pedido.
        me->change_purchase_order_alv( selected_lines ).
    ENDCASE.

    has_errors = reporter->has_errors( ).
    has_warnings = reporter->has_warnings( ).

    IF has_errors = abap_true OR has_warnings = abap_true.
      reporter->popup( ).
    ENDIF.

  ENDMETHOD.

  METHOD change_purchase_order.
    DATA: return_table       TYPE STANDARD TABLE OF bapiret2,
          msg                TYPE string,
          dal_4service_sheet TYPE REF TO /s4tax/idal_4service_sheet,
          reporter_sheet     TYPE REF TO /s4tax/ireporter.

    CREATE OBJECT dal_4service_sheet TYPE /s4tax/dal_4service_sheet.

    reporter_sheet = service_sheet->get_reporter( ).

    return_table = dal_4service_sheet->change_purchase_order( service_sheet ).

    READ TABLE return_table TRANSPORTING NO FIELDS WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      result = abap_true.
      call_bapi_transaction_commit( ).
    ELSE.
      MESSAGE e004(/s4tax/4service) WITH sy-datum
                                         service_sheet->struct-provider_fiscal_id_number
                                         service_sheet->struct-order_number INTO msg.
      reporter_sheet->error( msg ).
      call_bapi_transaction_rollback( ).
    ENDIF.

    result = log_bapi_return( bapi_return = return_table reporter = reporter_sheet ).
  ENDMETHOD.

  METHOD generate_migo.
    DATA: return             TYPE STANDARD TABLE OF bapiret2,
          msg                TYPE string,
          reporter_sheet     TYPE REF TO /s4tax/ireporter,
          dal_4service_sheet TYPE REF TO /s4tax/idal_4service_sheet.

    reporter_sheet = service_sheet->get_reporter( ).

    CREATE OBJECT dal_4service_sheet TYPE /s4tax/dal_4service_sheet.

    return = dal_4service_sheet->generate_migo( service_sheet ).

    READ TABLE return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      call_bapi_transaction_commit( ).
      result = abap_true.
      "service_sheet->set_itmref( item_created-matdoc_itm ).
    ELSE.
      service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
      call_bapi_transaction_rollback( ).
      MESSAGE e001(/s4tax/4service) WITH service_sheet->struct-order_number INTO msg.
      reporter_sheet->error( msg ).
    ENDIF.

    result = log_bapi_return( bapi_return = return reporter = reporter_sheet ).
  ENDMETHOD.

  METHOD call_bapi_goodsmvt_create.
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = goodsmvt_header
        goodsmvt_code    = goodsmvt_code
      IMPORTING
        goodsmvt_headret = goodsmvt_headret
      TABLES
        goodsmvt_item    = goodsmvt_item_table
        return           = result.
  ENDMETHOD.


  METHOD call_bapi_transaction_commit.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDMETHOD.

  METHOD call_bapi_transaction_rollback.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDMETHOD.

  METHOD log_bapi_return.

    DATA: return TYPE bapiret2,
          msg    TYPE string.

    LOOP AT bapi_return INTO return.
      CONCATENATE return-type return-id return-number return-message INTO msg SEPARATED BY '/'.
      IF return-type = 'E'.
        reporter->error( msg ).
        result = abap_false.
        CONTINUE.
      ENDIF.
      reporter->info( msg ).
    ENDLOOP.

  ENDMETHOD.

  METHOD call_bapi_po_change.
    DATA: poitem_table  TYPE bapimepoitem_tp,
          poitemx_table TYPE bapimepoitemx_tp.

    APPEND poitem TO poitem_table.
    APPEND poitemx TO poitemx_table.

    CALL FUNCTION 'BAPI_PO_CHANGE'
      EXPORTING
        purchaseorder = poheader-po_number
        poheader      = poheader
        poheaderx     = poheaderx
      TABLES
        return        = result
        poitem        = poitem_table
        poitemx       = poitemx_table.
  ENDMETHOD.

  METHOD create_ref_doc_supp_portal.

    CREATE OBJECT result.
    result->set_docref( sheet->struct-docref ).
    result->set_itmref( sheet->struct-itmref ).
    result->set_credat( sheet->struct-credat ).
    result->set_source( /s4tax/4service_constants=>source-pedido_compra ).
    result->set_updated_name( sy-uname ).

  ENDMETHOD.

  METHOD change_purchase_order_alv.
    DATA: selected_item      TYPE REF TO lvc_s_row,
          alv_line           TYPE REF TO /s4tax/s_appointments_4s_alv,
          service_sheet      TYPE REF TO /s4tax/4s_sheet,
          po_change_success  TYPE abap_bool,
          dao_4service_sheet TYPE REF TO /s4tax/idao_4service_sheet,
          service_sheet_list TYPE /s4tax/4s_sheet_t,
          reporter_sheet     TYPE REF TO /s4tax/ireporter,
          msg                TYPE string.

    LOOP AT selected_lines REFERENCE INTO selected_item.
      READ TABLE me->appointments_alv REFERENCE INTO alv_line INDEX selected_item->index.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      service_sheet = alv_line->service_sheet.
      reporter_sheet = service_sheet->get_reporter( ).

      IF service_sheet->struct-status_business <> /s4tax/4service_constants=>business_status-order_edit_error.
        MESSAGE e005(/s4tax/4service) INTO msg.
        reporter->error( msg ).
        RETURN.
      ENDIF.

      po_change_success = change_purchase_order( service_sheet ).

      IF po_change_success = abap_false.
        service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
        service_sheet->set_status_business( /s4tax/4service_constants=>business_status-order_edit_error ).
        CONTINUE.
      ENDIF.

      service_sheet->set_status_business( /s4tax/4service_constants=>business_status-order_edit_success ).
      APPEND service_sheet TO service_sheet_list.
    ENDLOOP.

    CREATE OBJECT dao_4service_sheet TYPE /s4tax/dao_4s_sheet.
    dao_4service_sheet->save_many( service_sheet_list ).
  ENDMETHOD.

  METHOD generate_migo_alv.
    DATA: selected_item         TYPE REF TO lvc_s_row,
          alv_line              TYPE REF TO /s4tax/s_appointments_4s_alv,
          service_sheet         TYPE REF TO /s4tax/4s_sheet,
          is_generated          TYPE abap_bool,
          dao_4service_sheet    TYPE REF TO /s4tax/idao_4service_sheet,
          reference_doc         TYPE REF TO /s4tax/supp_doc_reference,
          dao_sup_doc_reference TYPE REF TO /s4tax/idao_supp_doc_reference,
          reference_doc_list    TYPE /s4tax/supp_doc_reference_t,
          service_sheet_list    TYPE /s4tax/4s_sheet_t,
          msg                   TYPE string.

    LOOP AT selected_lines REFERENCE INTO selected_item.
      READ TABLE me->appointments_alv REFERENCE INTO alv_line INDEX selected_item->index.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      service_sheet = alv_line->service_sheet.

      IF service_sheet->struct-status_business <> /s4tax/4service_constants=>business_status-create_migo_error.
        MESSAGE e006(/s4tax/4service) INTO msg.
        reporter->error( msg ).
        CONTINUE.
      ENDIF.

      is_generated = generate_migo( service_sheet ).

      IF is_generated = abap_false.
        service_sheet->set_status( /s4tax/4service_constants=>timesheet_status-error ).
        service_sheet->set_status_business( /s4tax/4service_constants=>business_status-create_migo_error ).
        CONTINUE.
      ENDIF.

      service_sheet->set_status_business( /s4tax/4service_constants=>business_status-finished ).

      reference_doc = create_ref_doc_supp_portal( service_sheet ).
      APPEND reference_doc TO reference_doc_list.
      APPEND service_sheet TO service_sheet_list.
    ENDLOOP.
    CREATE OBJECT dao_4service_sheet TYPE /s4tax/dao_4s_sheet.
    CREATE OBJECT dao_sup_doc_reference TYPE /s4tax/dao_supp_doc_reference.

    dao_4service_sheet->save_many( service_sheet_list ).
    dao_sup_doc_reference->save_many( reference_doc_list ).
  ENDMETHOD.

ENDCLASS.

CLASS main DEFINITION.

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF c_okcode,
        cancel  TYPE sy-ucomm VALUE 'CANCEL',
        back    TYPE sy-ucomm VALUE 'BACK',
        exit    TYPE sy-ucomm VALUE 'EXIT',
        refresh TYPE sy-ucomm VALUE 'REFRESH',
      END OF c_okcode.

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
      alv_line-service_sheet = service_sheet.
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
      alv_line-order_item = service_sheet->get_order_item(  ).
      alv_line-order_number = service_sheet->get_order_number(  ).

      CREATE OBJECT date.
      IF alv_line-credat IS NOT INITIAL.
        date->create_by_timestamp( alv_line-credat ).
        alv_line-credat = date->to_usual_date_format(  ).
      ENDIF.

      IF alv_line-update_at IS NOT INITIAL.
        date->create_by_timestamp( alv_line-update_at ).
        alv_line-update_at = date->to_usual_date_format(  ).
      ENDIF.

      CASE service_sheet->struct-status_business.
        WHEN /s4tax/4service_constants=>business_status-order_edit_success.
          alv_line-status_business = ddic_utils->get_tooltip_icon( icon_name = icon_led_yellow text = TEXT-012 ).

        WHEN /s4tax/4service_constants=>business_status-create_migo_success OR
             /s4tax/4service_constants=>business_status-finished.
          alv_line-status_business = ddic_utils->get_tooltip_icon( icon_name = icon_led_green text = TEXT-009 ).

        WHEN /s4tax/4service_constants=>business_status-order_edit_error.
          alv_line-status_business = ddic_utils->get_tooltip_icon( icon_name = icon_led_red text = TEXT-011 ).

        WHEN /s4tax/4service_constants=>business_status-create_migo_error.
          alv_line-status_business = ddic_utils->get_tooltip_icon( icon_name = icon_led_red text = TEXT-010 ).
      ENDCASE.

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
      WHEN c_okcode-back.
        LEAVE TO SCREEN 0.

      WHEN c_okcode-exit OR c_okcode-cancel.
        LEAVE PROGRAM.

      WHEN c_okcode-refresh.
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
      date_last_day      TYPE REF TO /s4tax/date.


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

  CREATE OBJECT date_last_day EXPORTING date = first_day_of_month.
  date_last_day = date_last_day->last_day_of_month(  ).

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  s_date-low = first_day_of_month.
  s_date-high = date_last_day->date.
  s_date-sign = 'I'.
  s_date-option = 'EQ'.

  APPEND s_date.

  INCLUDE /s4tax/4service_monitor_sero01.

  INCLUDE /s4tax/4service_monitor_seri01.

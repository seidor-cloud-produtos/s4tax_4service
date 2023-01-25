CLASS /s4tax/dal_mkpf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS: abap.

    INTERFACES: /s4tax/idal_mkpf.

    METHODS:
      constructor IMPORTING dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: dao_pack_4service TYPE REF TO /s4tax/idao_pack_4service.
ENDCLASS.



CLASS /s4tax/dal_mkpf IMPLEMENTATION.
  METHOD /s4tax/idal_mkpf~fill_mseg_many_mkpf.
    DATA: dao_mkpf    TYPE REF TO /s4tax/idao_mkpf,
          dao_mseg    TYPE REF TO /s4tax/idao_mseg,
          mkpf_table  TYPE /s4tax/tmkpf_t,
          mblnr_range TYPE ace_generic_range_t,
          mseg_list   TYPE /s4tax/mseg_t,
          mkpf        TYPE REF TO /s4tax/mkpf,
          mseg        TYPE REF TO /s4tax/mseg,
          index       TYPE syst-tabix.

    IF mkpf_list IS INITIAL.
      RETURN.
    ENDIF.

    dao_mkpf = me->dao_pack_4service->mkpf(  ).
    dao_mseg = me->dao_pack_4service->mseg(  ).

    mkpf_table = dao_mkpf->objects_to_struct( mkpf_list ).

    mblnr_range = /s4tax/range_utils=>specific_range( range = mkpf_table low = 'MBLNR' ).
    mseg_list = dao_mseg->get_many_by_material( material_number_range = mblnr_range ).

    IF mseg_list IS INITIAL.
      RETURN.
    ENDIF.

    SORT mseg_list BY table_line->struct-mblnr table_line->struct-mjahr.

    LOOP AT mkpf_list INTO mkpf.
      READ TABLE mseg_list INTO mseg WITH KEY table_line->struct-mblnr = mkpf->struct-mblnr
                                              table_line->struct-mjahr = mkpf->struct-mjahr.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      index = sy-tabix.

      LOOP AT mseg_list INTO mseg FROM index.
        IF mseg->struct-mblnr <> mkpf->struct-mblnr OR mseg->struct-mjahr <> mkpf->struct-mjahr.
          EXIT.
        ENDIF.

        mkpf->add_mseg( mseg ).
      ENDLOOP.
    ENDLOOP.

    result = mseg_list.
  ENDMETHOD.

  METHOD constructor.
    me->dao_pack_4service = dao_pack_4service.
    IF me->dao_pack_4service IS NOT BOUND.
      me->dao_pack_4service = /s4tax/dao_pack_4service=>default_instance( ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.

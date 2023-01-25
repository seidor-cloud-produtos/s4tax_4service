CLASS /s4tax/dao_pack_4service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS abap .

    INTERFACES: /s4tax/idao_pack_4service.

    CLASS-METHODS:
      default_instance RETURNING VALUE(result) TYPE REF TO /s4tax/dao_pack_4service.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: instance TYPE REF TO /s4tax/dao_pack_4service.

    DATA: four_service_sheet TYPE REF TO /s4tax/idao_4service_sheet,
          mkpf               TYPE REF TO /s4tax/idao_mkpf,
          mseg               TYPE REF TO /s4tax/idao_mseg,
          mkpf_dal           TYPE REF TO /s4tax/idal_mkpf.
ENDCLASS.



CLASS /s4tax/dao_pack_4service IMPLEMENTATION.
  METHOD /s4tax/idao_pack_4service~four_service_sheet.
    IF me->four_service_sheet IS NOT BOUND.
      CREATE OBJECT me->four_service_sheet TYPE /s4tax/dao_4s_sheet.
    ENDIF.

    result = me->four_service_sheet.
  ENDMETHOD.

  METHOD default_instance.
    IF instance IS NOT BOUND.
      CREATE OBJECT instance.
    ENDIF.

    result = instance.
  ENDMETHOD.

  METHOD /s4tax/idao_pack_4service~mkpf.
    IF me->mkpf IS NOT BOUND.
      CREATE OBJECT me->mkpf TYPE /s4tax/dao_mkpf.
    ENDIF.

    result = me->mkpf.
  ENDMETHOD.

  METHOD /s4tax/idao_pack_4service~mseg.
    IF me->mseg IS NOT BOUND.
      CREATE OBJECT me->mseg TYPE /s4tax/dao_mseg.
    ENDIF.

    result = me->mseg.
  ENDMETHOD.

  METHOD /s4tax/idao_pack_4service~mkpf_dal.
    IF me->mkpf_dal IS NOT BOUND.
      CREATE OBJECT me->mkpf_dal TYPE /s4tax/dal_mkpf.
    ENDIF.

    result = me->mkpf_dal.
  ENDMETHOD.

ENDCLASS.

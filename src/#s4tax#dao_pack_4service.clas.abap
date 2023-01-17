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

    DATA: four_service_sheet TYPE REF TO /s4tax/idao_4service_sheet.
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

ENDCLASS.

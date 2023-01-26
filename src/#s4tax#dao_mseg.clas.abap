CLASS /s4tax/dao_mseg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS: abap.
    INTERFACES /s4tax/idao_mseg.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/dao_mseg IMPLEMENTATION.
  METHOD /s4tax/idao_mseg~objects_to_struct.
    DATA: material TYPE REF TO /s4tax/mseg.

    IF material_list IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT material_list INTO material.
      IF material IS NOT BOUND.
        CONTINUE.
      ENDIF.
      APPEND material->struct TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD /s4tax/idao_mseg~save.
    IF material IS NOT BOUND.
      RETURN.
    ENDIF.

    MODIFY mseg FROM material->struct.
  ENDMETHOD.

  METHOD /s4tax/idao_mseg~struct_to_objects.
    DATA: s_material TYPE mseg,
          material   TYPE REF TO /s4tax/mseg.

    IF material_table IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT material_table INTO s_material.
      CREATE OBJECT material EXPORTING iw_struct = s_material.
      APPEND material TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD /s4tax/idao_mseg~get_many_by_material.
    DATA: material TYPE /s4tax/tmseg_t.

    SELECT * FROM mseg
    INTO TABLE material
    WHERE mblnr IN material_number_range.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    result = me->/s4tax/idao_mseg~struct_to_objects( material ).
  ENDMETHOD.

ENDCLASS.

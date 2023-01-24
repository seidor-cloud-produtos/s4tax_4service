CLASS /s4tax/dao_mkpf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS: abap.
    INTERFACES /s4tax/idao_mkpf.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/dao_mkpf IMPLEMENTATION.
  METHOD /s4tax/idao_mkpf~save.
    IF material_doc IS NOT BOUND.
      RETURN.
    ENDIF.

    MODIFY mkpf FROM material_doc->struct.
  ENDMETHOD.

  METHOD /s4tax/idao_mkpf~get_many_by_material_doc.
    DATA: material TYPE /s4tax/tmkpf_t.

    SELECT * FROM mkpf
    INTO TABLE material
    WHERE mblnr IN material_number_range
    AND mjahr EQ material_year.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    result = me->/s4tax/idao_mkpf~struct_to_objects( material ).
  ENDMETHOD.

  METHOD /s4tax/idao_mkpf~objects_to_struct.
    DATA: material_doc TYPE REF TO /s4tax/mkpf.

    IF material_doc_list IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT material_doc_list INTO material_doc.
      IF material_doc IS NOT BOUND.
        CONTINUE.
      ENDIF.
      APPEND material_doc->struct TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD /s4tax/idao_mkpf~struct_to_objects.
    DATA: s_material_doc TYPE mkpf,
          material_doc   TYPE REF TO /s4tax/mkpf.

    IF material_doc_table IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT material_doc_table INTO s_material_doc.
      CREATE OBJECT material_doc EXPORTING iw_struct = s_material_doc.
      APPEND material_doc TO result.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

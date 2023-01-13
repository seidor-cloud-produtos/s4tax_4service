CLASS /s4tax/partner_create_4service DEFINITION
  PUBLIC
  INHERITING FROM /s4tax/partner_create
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING partner_integration TYPE REF TO /s4tax/ipartner_integration OPTIONAL
                            dao_pack_partner    TYPE REF TO /s4tax/idao_pack_partner OPTIONAL,
      /s4tax/ipartner_create~select REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: dao_pack_partner TYPE REF TO /s4tax/idao_pack_partner.
ENDCLASS.



CLASS /s4tax/partner_create_4service IMPLEMENTATION.

  METHOD /s4tax/ipartner_create~select.
    DATA: dal_partner   TYPE REF TO /s4tax/idal_partner,
          customer_list TYPE /s4tax/customer_t,
          provider_list TYPE /s4tax/supplier_t,
          fiscal_id     TYPE stcd1,
          parid         TYPE j_1bparid,
          provider      TYPE REF TO /s4tax/supplier,
          partner       TYPE REF TO /s4tax/partner,
          customer      TYPE REF TO /s4tax/customer.

    dal_partner = me->dao_pack_partner->partner_dal(  ).
    partners = dal_partner->get_partner_create_4service(  ).
  ENDMETHOD.

  METHOD constructor.

    super->constructor( partner_integration = partner_integration ).

    me->dao_pack_partner = dao_pack_partner.

    IF me->dao_pack_partner IS INITIAL.
      me->dao_pack_partner = /s4tax/dao_pack_partner=>default_instance( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

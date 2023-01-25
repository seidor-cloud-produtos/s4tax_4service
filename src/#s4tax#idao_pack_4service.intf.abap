INTERFACE /s4tax/idao_pack_4service
  PUBLIC .
  TYPE-POOLS abap .

  METHODS:
    four_service_sheet RETURNING VALUE(result) TYPE REF TO /s4tax/idao_4service_sheet,
    mkpf RETURNING VALUE(result) TYPE REF TO /s4tax/idao_mkpf,
    mseg RETURNING VALUE(result) TYPE REF TO /s4tax/idao_mseg,
    mkpf_dal RETURNING VALUE(result) TYPE REF TO /s4tax/idal_mkpf.

ENDINTERFACE.

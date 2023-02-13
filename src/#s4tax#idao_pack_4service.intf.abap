INTERFACE /s4tax/idao_pack_4service
  PUBLIC .
  TYPE-POOLS abap .

  METHODS:
    four_service_sheet RETURNING VALUE(result) TYPE REF TO /s4tax/idao_4service_sheet,
    material_document RETURNING VALUE(result) TYPE REF TO /s4tax/idao_material_document,
    material_doc_seg RETURNING VALUE(result) TYPE REF TO /s4tax/idao_material_doc_seg,
    material_document_dal RETURNING VALUE(result) TYPE REF TO /s4tax/idal_material_document,
    dal_4service_sheet RETURNING VALUE(result) TYPE REF TO /s4tax/idal_4service_sheet.

ENDINTERFACE.

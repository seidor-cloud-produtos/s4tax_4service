INTERFACE /s4tax/iapi_4service
  PUBLIC .
  TYPE-POOLS abap .

  METHODS:
    list_appoint_apvd_by_providers RETURNING VALUE(output) TYPE /s4tax/s_apvd_appoint_list_o.

ENDINTERFACE.

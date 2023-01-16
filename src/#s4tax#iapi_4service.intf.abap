INTERFACE /s4tax/iapi_4service
  PUBLIC .
  TYPE-POOLS abap .

  METHODS:
    list_appoint_apvd_by_providers RETURNING VALUE(result) TYPE /s4tax/s_apvd_appoint_list_o
                                   RAISING   /s4tax/cx_http,
    list_worked_hours_by_providers RETURNING VALUE(result) TYPE /s4tax/s_worked_hours_provid_o
                                   RAISING   /s4tax/cx_http.

ENDINTERFACE.

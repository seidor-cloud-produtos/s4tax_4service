INTERFACE /s4tax/idal_mkpf
  PUBLIC .

  METHODS:
    fill_mseg_many_mkpf IMPORTING mkpf_list     TYPE /s4tax/mkpf_t
                        RETURNING VALUE(result) TYPE /s4tax/mseg_t.

ENDINTERFACE.

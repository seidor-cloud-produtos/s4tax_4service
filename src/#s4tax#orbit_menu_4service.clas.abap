CLASS /s4tax/orbit_menu_4service DEFINITION
 INHERITING FROM /s4tax/orbit_menu_abs
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: constructor IMPORTING tran_list     TYPE /s4tax/object_catalog_t
                                   package_table TYPE /s4tax/tdevc_t OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/orbit_menu_4service IMPLEMENTATION.

  METHOD constructor.
    DATA: module_name TYPE string.

    module_name = TEXT-001.
    super->constructor( transaction_list = tran_list
                        module_name = module_name
                        package = /s4tax/constants=>package_name-srv_4service
                        package_table = package_table ).
  ENDMETHOD.

ENDCLASS.

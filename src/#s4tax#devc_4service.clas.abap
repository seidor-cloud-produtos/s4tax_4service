CLASS /s4tax/devc_4service DEFINITION
  PUBLIC
  INHERITING FROM /s4tax/versionable_abs
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/devc_4service IMPLEMENTATION.
  METHOD constructor.

    DATA: dependency_list TYPE REF TO /s4tax/obj_dependency_list.

    CREATE OBJECT dependency_list.

    dependency_list->add_dependency_by_name(
            component_name   = 'Orbit-Partner'
          expected_version = '23.01.1'
        ).

    super->constructor( component_name = 'Orbit-4Service'
                        full_version = '23.01.1'
                        dependency_list = dependency_list ).

  ENDMETHOD.

ENDCLASS.

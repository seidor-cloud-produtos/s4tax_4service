CLASS /s4tax/material_document DEFINITION
  PUBLIC
  INHERITING FROM /s4tax/model_mkpf
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS: constructor IMPORTING iw_struct TYPE mkpf OPTIONAL,
      add_material_doc_segment IMPORTING material_doc_segment TYPE REF TO /s4tax/material_document_seg,
      get_material_doc_segment_list RETURNING VALUE(result) TYPE /s4tax/material_document_seg_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: material_doc_segment_list TYPE /s4tax/material_document_seg_t.

ENDCLASS.



CLASS /s4tax/material_document IMPLEMENTATION.


  METHOD add_material_doc_segment.
    IF material_doc_segment IS INITIAL.
      RETURN.
    ENDIF.

    APPEND material_doc_segment TO me->material_doc_segment_list.
  ENDMETHOD.


  METHOD constructor.

    super->constructor( ).

    IF iw_struct IS INITIAL.
      RETURN.
    ENDIF.

    me->set_mblnr( iw_struct-mblnr ).
    me->set_mjahr( iw_struct-mjahr ).
    me->set_vgart( iw_struct-vgart ).
    me->set_blart( iw_struct-blart ).
    me->set_blaum( iw_struct-blaum ).
    me->set_bldat( iw_struct-bldat ).
    me->set_budat( iw_struct-budat ).
    me->set_cpudt( iw_struct-cpudt ).
    me->set_cputm( iw_struct-cputm ).
    me->set_aedat( iw_struct-aedat ).
    me->set_usnam( iw_struct-usnam ).
    me->set_tcode( iw_struct-tcode ).
    me->set_xblnr( iw_struct-xblnr ).
    me->set_bktxt( iw_struct-bktxt ).
    me->set_frath( iw_struct-frath ).
    me->set_frbnr( iw_struct-frbnr ).
    me->set_wever( iw_struct-wever ).
    me->set_xabln( iw_struct-xabln ).
    me->set_awsys( iw_struct-awsys ).
    me->set_bla2d( iw_struct-bla2d ).
    me->set_tcode2( iw_struct-tcode2 ).
    me->set_bfwms( iw_struct-bfwms ).
    me->set_exnum( iw_struct-exnum ).
    me->set_spe_budat_uhr( iw_struct-spe_budat_uhr ).
    me->set_spe_budat_zone( iw_struct-spe_budat_zone ).
    me->set_le_vbeln( iw_struct-le_vbeln ).
    me->set_spe_logsys( iw_struct-spe_logsys ).
    me->set_spe_mdnum_ewm( iw_struct-spe_mdnum_ewm ).
    me->set_gts_cusref_no( iw_struct-gts_cusref_no ).
    me->set_fls_rsto( iw_struct-fls_rsto ).
    me->set_msr_active( iw_struct-msr_active ).
    me->set_knumv( iw_struct-knumv ).
    me->set_xcompl( iw_struct-xcompl ).
  ENDMETHOD.


  METHOD get_material_doc_segment_list.
    result = me->material_doc_segment_list.
  ENDMETHOD.
ENDCLASS.

CLASS /s4tax/material_document_seg DEFINITION
  PUBLIC
  INHERITING FROM /s4tax/model_mseg
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor IMPORTING iw_struct TYPE mseg OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/material_document_seg IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    me->set_mblnr( iw_struct-mblnr ).
    me->set_mjahr( iw_struct-mjahr ).
    me->set_zeile( iw_struct-zeile ).
    me->set_line_id( iw_struct-line_id ).
    me->set_parent_id( iw_struct-parent_id ).
    me->set_line_depth( iw_struct-line_depth ).
    me->set_maa_urzei( iw_struct-maa_urzei ).
    me->set_bwart( iw_struct-bwart ).
    me->set_xauto( iw_struct-xauto ).
    me->set_matnr( iw_struct-matnr ).
    me->set_werks( iw_struct-werks ).
    me->set_lgort( iw_struct-lgort ).
    me->set_charg( iw_struct-charg ).
    me->set_insmk( iw_struct-insmk ).
    me->set_zusch( iw_struct-zusch ).
    me->set_zustd( iw_struct-zustd ).
    me->set_sobkz( iw_struct-sobkz ).
    me->set_lifnr( iw_struct-lifnr ).
    me->set_kunnr( iw_struct-kunnr ).
    me->set_kdauf( iw_struct-kdauf ).
    me->set_kdpos( iw_struct-kdpos ).
    me->set_kdein( iw_struct-kdein ).
    me->set_plpla( iw_struct-plpla ).
    me->set_shkzg( iw_struct-shkzg ).
    me->set_waers( iw_struct-waers ).
    me->set_dmbtr( iw_struct-dmbtr ).
    me->set_bnbtr( iw_struct-bnbtr ).
    me->set_bualt( iw_struct-bualt ).
    me->set_shkum( iw_struct-shkum ).
    me->set_dmbum( iw_struct-dmbum ).
    me->set_bwtar( iw_struct-bwtar ).
    me->set_menge( iw_struct-menge ).
    me->set_meins( iw_struct-meins ).
    me->set_erfmg( iw_struct-erfmg ).
    me->set_erfme( iw_struct-erfme ).
    me->set_bpmng( iw_struct-bpmng ).
    me->set_bprme( iw_struct-bprme ).
    me->set_ebeln( iw_struct-ebeln ).
    me->set_ebelp( iw_struct-ebelp ).
    me->set_lfbja( iw_struct-lfbja ).
    me->set_lfbnr( iw_struct-lfbnr ).
    me->set_lfpos( iw_struct-lfpos ).
    me->set_sjahr( iw_struct-sjahr ).
    me->set_smbln( iw_struct-smbln ).
    me->set_smblp( iw_struct-smblp ).
    me->set_elikz( iw_struct-elikz ).
    me->set_sgtxt( iw_struct-sgtxt ).
    me->set_equnr( iw_struct-equnr ).
    me->set_wempf( iw_struct-wempf ).
    me->set_ablad( iw_struct-ablad ).
    me->set_gsber( iw_struct-gsber ).

  ENDMETHOD.
ENDCLASS.

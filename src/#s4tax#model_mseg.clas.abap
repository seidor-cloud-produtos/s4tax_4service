CLASS /s4tax/model_mseg DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: struct TYPE mseg READ-ONLY.

    METHODS: get_mblnr
      RETURNING VALUE(result) TYPE mseg-mblnr.


    METHODS: set_mblnr
      IMPORTING iv_mblnr TYPE mseg-mblnr.


    METHODS: get_mjahr
      RETURNING VALUE(result) TYPE mseg-mjahr.


    METHODS: set_mjahr
      IMPORTING iv_mjahr TYPE mseg-mjahr.


    METHODS: get_zeile
      RETURNING VALUE(result) TYPE mseg-zeile.


    METHODS: set_zeile
      IMPORTING iv_zeile TYPE mseg-zeile.


    METHODS: get_line_id
      RETURNING VALUE(result) TYPE mseg-line_id.


    METHODS: set_line_id
      IMPORTING iv_line_id TYPE mseg-line_id.


    METHODS: get_parent_id
      RETURNING VALUE(result) TYPE mseg-parent_id.


    METHODS: set_parent_id
      IMPORTING iv_parent_id TYPE mseg-parent_id.


    METHODS: get_line_depth
      RETURNING VALUE(result) TYPE mseg-line_depth.


    METHODS: set_line_depth
      IMPORTING iv_line_depth TYPE mseg-line_depth.


    METHODS: get_maa_urzei
      RETURNING VALUE(result) TYPE mseg-maa_urzei.


    METHODS: set_maa_urzei
      IMPORTING iv_maa_urzei TYPE mseg-maa_urzei.


    METHODS: get_bwart
      RETURNING VALUE(result) TYPE mseg-bwart.


    METHODS: set_bwart
      IMPORTING iv_bwart TYPE mseg-bwart.


    METHODS: get_xauto
      RETURNING VALUE(result) TYPE mseg-xauto.


    METHODS: set_xauto
      IMPORTING iv_xauto TYPE mseg-xauto.


    METHODS: get_matnr
      RETURNING VALUE(result) TYPE mseg-matnr.


    METHODS: set_matnr
      IMPORTING iv_matnr TYPE mseg-matnr.


    METHODS: get_werks
      RETURNING VALUE(result) TYPE mseg-werks.


    METHODS: set_werks
      IMPORTING iv_werks TYPE mseg-werks.


    METHODS: get_lgort
      RETURNING VALUE(result) TYPE mseg-lgort.


    METHODS: set_lgort
      IMPORTING iv_lgort TYPE mseg-lgort.


    METHODS: get_charg
      RETURNING VALUE(result) TYPE mseg-charg.


    METHODS: set_charg
      IMPORTING iv_charg TYPE mseg-charg.


    METHODS: get_insmk
      RETURNING VALUE(result) TYPE mseg-insmk.


    METHODS: set_insmk
      IMPORTING iv_insmk TYPE mseg-insmk.


    METHODS: get_zusch
      RETURNING VALUE(result) TYPE mseg-zusch.


    METHODS: set_zusch
      IMPORTING iv_zusch TYPE mseg-zusch.


    METHODS: get_zustd
      RETURNING VALUE(result) TYPE mseg-zustd.


    METHODS: set_zustd
      IMPORTING iv_zustd TYPE mseg-zustd.


    METHODS: get_sobkz
      RETURNING VALUE(result) TYPE mseg-sobkz.


    METHODS: set_sobkz
      IMPORTING iv_sobkz TYPE mseg-sobkz.


    METHODS: get_lifnr
      RETURNING VALUE(result) TYPE mseg-lifnr.


    METHODS: set_lifnr
      IMPORTING iv_lifnr TYPE mseg-lifnr.


    METHODS: get_kunnr
      RETURNING VALUE(result) TYPE mseg-kunnr.


    METHODS: set_kunnr
      IMPORTING iv_kunnr TYPE mseg-kunnr.


    METHODS: get_kdauf
      RETURNING VALUE(result) TYPE mseg-kdauf.


    METHODS: set_kdauf
      IMPORTING iv_kdauf TYPE mseg-kdauf.


    METHODS: get_kdpos
      RETURNING VALUE(result) TYPE mseg-kdpos.


    METHODS: set_kdpos
      IMPORTING iv_kdpos TYPE mseg-kdpos.


    METHODS: get_kdein
      RETURNING VALUE(result) TYPE mseg-kdein.


    METHODS: set_kdein
      IMPORTING iv_kdein TYPE mseg-kdein.


    METHODS: get_plpla
      RETURNING VALUE(result) TYPE mseg-plpla.


    METHODS: set_plpla
      IMPORTING iv_plpla TYPE mseg-plpla.


    METHODS: get_shkzg
      RETURNING VALUE(result) TYPE mseg-shkzg.


    METHODS: set_shkzg
      IMPORTING iv_shkzg TYPE mseg-shkzg.


    METHODS: get_waers
      RETURNING VALUE(result) TYPE mseg-waers.


    METHODS: set_waers
      IMPORTING iv_waers TYPE mseg-waers.


    METHODS: get_dmbtr
      RETURNING VALUE(result) TYPE mseg-dmbtr.


    METHODS: set_dmbtr
      IMPORTING iv_dmbtr TYPE mseg-dmbtr.


    METHODS: get_bnbtr
      RETURNING VALUE(result) TYPE mseg-bnbtr.


    METHODS: set_bnbtr
      IMPORTING iv_bnbtr TYPE mseg-bnbtr.


    METHODS: get_bualt
      RETURNING VALUE(result) TYPE mseg-bualt.


    METHODS: set_bualt
      IMPORTING iv_bualt TYPE mseg-bualt.


    METHODS: get_shkum
      RETURNING VALUE(result) TYPE mseg-shkum.


    METHODS: set_shkum
      IMPORTING iv_shkum TYPE mseg-shkum.


    METHODS: get_dmbum
      RETURNING VALUE(result) TYPE mseg-dmbum.


    METHODS: set_dmbum
      IMPORTING iv_dmbum TYPE mseg-dmbum.


    METHODS: get_bwtar
      RETURNING VALUE(result) TYPE mseg-bwtar.


    METHODS: set_bwtar
      IMPORTING iv_bwtar TYPE mseg-bwtar.


    METHODS: get_menge
      RETURNING VALUE(result) TYPE mseg-menge.


    METHODS: set_menge
      IMPORTING iv_menge TYPE mseg-menge.


    METHODS: get_meins
      RETURNING VALUE(result) TYPE mseg-meins.


    METHODS: set_meins
      IMPORTING iv_meins TYPE mseg-meins.


    METHODS: get_erfmg
      RETURNING VALUE(result) TYPE mseg-erfmg.


    METHODS: set_erfmg
      IMPORTING iv_erfmg TYPE mseg-erfmg.


    METHODS: get_erfme
      RETURNING VALUE(result) TYPE mseg-erfme.


    METHODS: set_erfme
      IMPORTING iv_erfme TYPE mseg-erfme.


    METHODS: get_bpmng
      RETURNING VALUE(result) TYPE mseg-bpmng.


    METHODS: set_bpmng
      IMPORTING iv_bpmng TYPE mseg-bpmng.


    METHODS: get_bprme
      RETURNING VALUE(result) TYPE mseg-bprme.


    METHODS: set_bprme
      IMPORTING iv_bprme TYPE mseg-bprme.


    METHODS: get_ebeln
      RETURNING VALUE(result) TYPE mseg-ebeln.


    METHODS: set_ebeln
      IMPORTING iv_ebeln TYPE mseg-ebeln.


    METHODS: get_ebelp
      RETURNING VALUE(result) TYPE mseg-ebelp.


    METHODS: set_ebelp
      IMPORTING iv_ebelp TYPE mseg-ebelp.


    METHODS: get_lfbja
      RETURNING VALUE(result) TYPE mseg-lfbja.


    METHODS: set_lfbja
      IMPORTING iv_lfbja TYPE mseg-lfbja.


    METHODS: get_lfbnr
      RETURNING VALUE(result) TYPE mseg-lfbnr.


    METHODS: set_lfbnr
      IMPORTING iv_lfbnr TYPE mseg-lfbnr.


    METHODS: get_lfpos
      RETURNING VALUE(result) TYPE mseg-lfpos.


    METHODS: set_lfpos
      IMPORTING iv_lfpos TYPE mseg-lfpos.


    METHODS: get_sjahr
      RETURNING VALUE(result) TYPE mseg-sjahr.


    METHODS: set_sjahr
      IMPORTING iv_sjahr TYPE mseg-sjahr.


    METHODS: get_smbln
      RETURNING VALUE(result) TYPE mseg-smbln.


    METHODS: set_smbln
      IMPORTING iv_smbln TYPE mseg-smbln.


    METHODS: get_smblp
      RETURNING VALUE(result) TYPE mseg-smblp.


    METHODS: set_smblp
      IMPORTING iv_smblp TYPE mseg-smblp.


    METHODS: get_elikz
      RETURNING VALUE(result) TYPE mseg-elikz.


    METHODS: set_elikz
      IMPORTING iv_elikz TYPE mseg-elikz.


    METHODS: get_sgtxt
      RETURNING VALUE(result) TYPE mseg-sgtxt.


    METHODS: set_sgtxt
      IMPORTING iv_sgtxt TYPE mseg-sgtxt.


    METHODS: get_equnr
      RETURNING VALUE(result) TYPE mseg-equnr.


    METHODS: set_equnr
      IMPORTING iv_equnr TYPE mseg-equnr.


    METHODS: get_wempf
      RETURNING VALUE(result) TYPE mseg-wempf.


    METHODS: set_wempf
      IMPORTING iv_wempf TYPE mseg-wempf.


    METHODS: get_ablad
      RETURNING VALUE(result) TYPE mseg-ablad.


    METHODS: set_ablad
      IMPORTING iv_ablad TYPE mseg-ablad.


    METHODS: get_gsber
      RETURNING VALUE(result) TYPE mseg-gsber.


    METHODS: set_gsber
      IMPORTING iv_gsber TYPE mseg-gsber.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/model_mseg IMPLEMENTATION.

  METHOD get_mblnr.
    result = me->struct-mblnr.
  ENDMETHOD.


  METHOD set_mblnr.
    me->struct-mblnr = iv_mblnr.
  ENDMETHOD.


  METHOD get_mjahr.
    result = me->struct-mjahr.
  ENDMETHOD.


  METHOD set_mjahr.
    me->struct-mjahr = iv_mjahr.
  ENDMETHOD.


  METHOD get_zeile.
    result = me->struct-zeile.
  ENDMETHOD.


  METHOD set_zeile.
    me->struct-zeile = iv_zeile.
  ENDMETHOD.


  METHOD get_line_id.
    result = me->struct-line_id.
  ENDMETHOD.


  METHOD set_line_id.
    me->struct-line_id = iv_line_id.
  ENDMETHOD.


  METHOD get_parent_id.
    result = me->struct-parent_id.
  ENDMETHOD.


  METHOD set_parent_id.
    me->struct-parent_id = iv_parent_id.
  ENDMETHOD.


  METHOD get_line_depth.
    result = me->struct-line_depth.
  ENDMETHOD.


  METHOD set_line_depth.
    me->struct-line_depth = iv_line_depth.
  ENDMETHOD.


  METHOD get_maa_urzei.
    result = me->struct-maa_urzei.
  ENDMETHOD.


  METHOD set_maa_urzei.
    me->struct-maa_urzei = iv_maa_urzei.
  ENDMETHOD.


  METHOD get_bwart.
    result = me->struct-bwart.
  ENDMETHOD.


  METHOD set_bwart.
    me->struct-bwart = iv_bwart.
  ENDMETHOD.


  METHOD get_xauto.
    result = me->struct-xauto.
  ENDMETHOD.


  METHOD set_xauto.
    me->struct-xauto = iv_xauto.
  ENDMETHOD.


  METHOD get_matnr.
    result = me->struct-matnr.
  ENDMETHOD.


  METHOD set_matnr.
    me->struct-matnr = iv_matnr.
  ENDMETHOD.


  METHOD get_werks.
    result = me->struct-werks.
  ENDMETHOD.


  METHOD set_werks.
    me->struct-werks = iv_werks.
  ENDMETHOD.


  METHOD get_lgort.
    result = me->struct-lgort.
  ENDMETHOD.


  METHOD set_lgort.
    me->struct-lgort = iv_lgort.
  ENDMETHOD.


  METHOD get_charg.
    result = me->struct-charg.
  ENDMETHOD.


  METHOD set_charg.
    me->struct-charg = iv_charg.
  ENDMETHOD.


  METHOD get_insmk.
    result = me->struct-insmk.
  ENDMETHOD.


  METHOD set_insmk.
    me->struct-insmk = iv_insmk.
  ENDMETHOD.


  METHOD get_zusch.
    result = me->struct-zusch.
  ENDMETHOD.


  METHOD set_zusch.
    me->struct-zusch = iv_zusch.
  ENDMETHOD.


  METHOD get_zustd.
    result = me->struct-zustd.
  ENDMETHOD.


  METHOD set_zustd.
    me->struct-zustd = iv_zustd.
  ENDMETHOD.


  METHOD get_sobkz.
    result = me->struct-sobkz.
  ENDMETHOD.


  METHOD set_sobkz.
    me->struct-sobkz = iv_sobkz.
  ENDMETHOD.


  METHOD get_lifnr.
    result = me->struct-lifnr.
  ENDMETHOD.


  METHOD set_lifnr.
    me->struct-lifnr = iv_lifnr.
  ENDMETHOD.


  METHOD get_kunnr.
    result = me->struct-kunnr.
  ENDMETHOD.


  METHOD set_kunnr.
    me->struct-kunnr = iv_kunnr.
  ENDMETHOD.


  METHOD get_kdauf.
    result = me->struct-kdauf.
  ENDMETHOD.


  METHOD set_kdauf.
    me->struct-kdauf = iv_kdauf.
  ENDMETHOD.


  METHOD get_kdpos.
    result = me->struct-kdpos.
  ENDMETHOD.


  METHOD set_kdpos.
    me->struct-kdpos = iv_kdpos.
  ENDMETHOD.


  METHOD get_kdein.
    result = me->struct-kdein.
  ENDMETHOD.


  METHOD set_kdein.
    me->struct-kdein = iv_kdein.
  ENDMETHOD.


  METHOD get_plpla.
    result = me->struct-plpla.
  ENDMETHOD.


  METHOD set_plpla.
    me->struct-plpla = iv_plpla.
  ENDMETHOD.


  METHOD get_shkzg.
    result = me->struct-shkzg.
  ENDMETHOD.


  METHOD set_shkzg.
    me->struct-shkzg = iv_shkzg.
  ENDMETHOD.


  METHOD get_waers.
    result = me->struct-waers.
  ENDMETHOD.


  METHOD set_waers.
    me->struct-waers = iv_waers.
  ENDMETHOD.


  METHOD get_dmbtr.
    result = me->struct-dmbtr.
  ENDMETHOD.


  METHOD set_dmbtr.
    me->struct-dmbtr = iv_dmbtr.
  ENDMETHOD.


  METHOD get_bnbtr.
    result = me->struct-bnbtr.
  ENDMETHOD.


  METHOD set_bnbtr.
    me->struct-bnbtr = iv_bnbtr.
  ENDMETHOD.


  METHOD get_bualt.
    result = me->struct-bualt.
  ENDMETHOD.


  METHOD set_bualt.
    me->struct-bualt = iv_bualt.
  ENDMETHOD.


  METHOD get_shkum.
    result = me->struct-shkum.
  ENDMETHOD.


  METHOD set_shkum.
    me->struct-shkum = iv_shkum.
  ENDMETHOD.


  METHOD get_dmbum.
    result = me->struct-dmbum.
  ENDMETHOD.


  METHOD set_dmbum.
    me->struct-dmbum = iv_dmbum.
  ENDMETHOD.


  METHOD get_bwtar.
    result = me->struct-bwtar.
  ENDMETHOD.


  METHOD set_bwtar.
    me->struct-bwtar = iv_bwtar.
  ENDMETHOD.


  METHOD get_menge.
    result = me->struct-menge.
  ENDMETHOD.


  METHOD set_menge.
    me->struct-menge = iv_menge.
  ENDMETHOD.


  METHOD get_meins.
    result = me->struct-meins.
  ENDMETHOD.


  METHOD set_meins.
    me->struct-meins = iv_meins.
  ENDMETHOD.


  METHOD get_erfmg.
    result = me->struct-erfmg.
  ENDMETHOD.


  METHOD set_erfmg.
    me->struct-erfmg = iv_erfmg.
  ENDMETHOD.


  METHOD get_erfme.
    result = me->struct-erfme.
  ENDMETHOD.


  METHOD set_erfme.
    me->struct-erfme = iv_erfme.
  ENDMETHOD.


  METHOD get_bpmng.
    result = me->struct-bpmng.
  ENDMETHOD.


  METHOD set_bpmng.
    me->struct-bpmng = iv_bpmng.
  ENDMETHOD.


  METHOD get_bprme.
    result = me->struct-bprme.
  ENDMETHOD.


  METHOD set_bprme.
    me->struct-bprme = iv_bprme.
  ENDMETHOD.


  METHOD get_ebeln.
    result = me->struct-ebeln.
  ENDMETHOD.


  METHOD set_ebeln.
    me->struct-ebeln = iv_ebeln.
  ENDMETHOD.


  METHOD get_ebelp.
    result = me->struct-ebelp.
  ENDMETHOD.


  METHOD set_ebelp.
    me->struct-ebelp = iv_ebelp.
  ENDMETHOD.


  METHOD get_lfbja.
    result = me->struct-lfbja.
  ENDMETHOD.


  METHOD set_lfbja.
    me->struct-lfbja = iv_lfbja.
  ENDMETHOD.


  METHOD get_lfbnr.
    result = me->struct-lfbnr.
  ENDMETHOD.


  METHOD set_lfbnr.
    me->struct-lfbnr = iv_lfbnr.
  ENDMETHOD.


  METHOD get_lfpos.
    result = me->struct-lfpos.
  ENDMETHOD.


  METHOD set_lfpos.
    me->struct-lfpos = iv_lfpos.
  ENDMETHOD.


  METHOD get_sjahr.
    result = me->struct-sjahr.
  ENDMETHOD.


  METHOD set_sjahr.
    me->struct-sjahr = iv_sjahr.
  ENDMETHOD.


  METHOD get_smbln.
    result = me->struct-smbln.
  ENDMETHOD.


  METHOD set_smbln.
    me->struct-smbln = iv_smbln.
  ENDMETHOD.


  METHOD get_smblp.
    result = me->struct-smblp.
  ENDMETHOD.


  METHOD set_smblp.
    me->struct-smblp = iv_smblp.
  ENDMETHOD.


  METHOD get_elikz.
    result = me->struct-elikz.
  ENDMETHOD.


  METHOD set_elikz.
    me->struct-elikz = iv_elikz.
  ENDMETHOD.


  METHOD get_sgtxt.
    result = me->struct-sgtxt.
  ENDMETHOD.


  METHOD set_sgtxt.
    me->struct-sgtxt = iv_sgtxt.
  ENDMETHOD.


  METHOD get_equnr.
    result = me->struct-equnr.
  ENDMETHOD.


  METHOD set_equnr.
    me->struct-equnr = iv_equnr.
  ENDMETHOD.


  METHOD get_wempf.
    result = me->struct-wempf.
  ENDMETHOD.


  METHOD set_wempf.
    me->struct-wempf = iv_wempf.
  ENDMETHOD.


  METHOD get_ablad.
    result = me->struct-ablad.
  ENDMETHOD.


  METHOD set_ablad.
    me->struct-ablad = iv_ablad.
  ENDMETHOD.


  METHOD get_gsber.
    result = me->struct-gsber.
  ENDMETHOD.


  METHOD set_gsber.
    me->struct-gsber = iv_gsber.
  ENDMETHOD.



ENDCLASS.

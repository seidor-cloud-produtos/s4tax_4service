class /S4TAX/MATERIAL_DOC_SEGMENT definition
  public
  create public .

public section.

  data STRUCT type MSEG read-only .

  methods GET_MBLNR
    returning
      value(RESULT) type MSEG-MBLNR .
  methods SET_MBLNR
    importing
      !IV_MBLNR type MSEG-MBLNR .
  methods GET_MJAHR
    returning
      value(RESULT) type MSEG-MJAHR .
  methods SET_MJAHR
    importing
      !IV_MJAHR type MSEG-MJAHR .
  methods GET_ZEILE
    returning
      value(RESULT) type MSEG-ZEILE .
  methods SET_ZEILE
    importing
      !IV_ZEILE type MSEG-ZEILE .
  methods GET_LINE_ID
    returning
      value(RESULT) type MSEG-LINE_ID .
  methods SET_LINE_ID
    importing
      !IV_LINE_ID type MSEG-LINE_ID .
  methods GET_PARENT_ID
    returning
      value(RESULT) type MSEG-PARENT_ID .
  methods SET_PARENT_ID
    importing
      !IV_PARENT_ID type MSEG-PARENT_ID .
  methods GET_LINE_DEPTH
    returning
      value(RESULT) type MSEG-LINE_DEPTH .
  methods SET_LINE_DEPTH
    importing
      !IV_LINE_DEPTH type MSEG-LINE_DEPTH .
  methods GET_MAA_URZEI
    returning
      value(RESULT) type MSEG-MAA_URZEI .
  methods SET_MAA_URZEI
    importing
      !IV_MAA_URZEI type MSEG-MAA_URZEI .
  methods GET_BWART
    returning
      value(RESULT) type MSEG-BWART .
  methods SET_BWART
    importing
      !IV_BWART type MSEG-BWART .
  methods GET_XAUTO
    returning
      value(RESULT) type MSEG-XAUTO .
  methods SET_XAUTO
    importing
      !IV_XAUTO type MSEG-XAUTO .
  methods GET_MATNR
    returning
      value(RESULT) type MSEG-MATNR .
  methods SET_MATNR
    importing
      !IV_MATNR type MSEG-MATNR .
  methods GET_WERKS
    returning
      value(RESULT) type MSEG-WERKS .
  methods SET_WERKS
    importing
      !IV_WERKS type MSEG-WERKS .
  methods GET_LGORT
    returning
      value(RESULT) type MSEG-LGORT .
  methods SET_LGORT
    importing
      !IV_LGORT type MSEG-LGORT .
  methods GET_CHARG
    returning
      value(RESULT) type MSEG-CHARG .
  methods SET_CHARG
    importing
      !IV_CHARG type MSEG-CHARG .
  methods GET_INSMK
    returning
      value(RESULT) type MSEG-INSMK .
  methods SET_INSMK
    importing
      !IV_INSMK type MSEG-INSMK .
  methods GET_ZUSCH
    returning
      value(RESULT) type MSEG-ZUSCH .
  methods SET_ZUSCH
    importing
      !IV_ZUSCH type MSEG-ZUSCH .
  methods GET_ZUSTD
    returning
      value(RESULT) type MSEG-ZUSTD .
  methods SET_ZUSTD
    importing
      !IV_ZUSTD type MSEG-ZUSTD .
  methods GET_SOBKZ
    returning
      value(RESULT) type MSEG-SOBKZ .
  methods SET_SOBKZ
    importing
      !IV_SOBKZ type MSEG-SOBKZ .
  methods GET_LIFNR
    returning
      value(RESULT) type MSEG-LIFNR .
  methods SET_LIFNR
    importing
      !IV_LIFNR type MSEG-LIFNR .
  methods GET_KUNNR
    returning
      value(RESULT) type MSEG-KUNNR .
  methods SET_KUNNR
    importing
      !IV_KUNNR type MSEG-KUNNR .
  methods GET_KDAUF
    returning
      value(RESULT) type MSEG-KDAUF .
  methods SET_KDAUF
    importing
      !IV_KDAUF type MSEG-KDAUF .
  methods GET_KDPOS
    returning
      value(RESULT) type MSEG-KDPOS .
  methods SET_KDPOS
    importing
      !IV_KDPOS type MSEG-KDPOS .
  methods GET_KDEIN
    returning
      value(RESULT) type MSEG-KDEIN .
  methods SET_KDEIN
    importing
      !IV_KDEIN type MSEG-KDEIN .
  methods GET_PLPLA
    returning
      value(RESULT) type MSEG-PLPLA .
  methods SET_PLPLA
    importing
      !IV_PLPLA type MSEG-PLPLA .
  methods GET_SHKZG
    returning
      value(RESULT) type MSEG-SHKZG .
  methods SET_SHKZG
    importing
      !IV_SHKZG type MSEG-SHKZG .
  methods GET_WAERS
    returning
      value(RESULT) type MSEG-WAERS .
  methods SET_WAERS
    importing
      !IV_WAERS type MSEG-WAERS .
  methods GET_DMBTR
    returning
      value(RESULT) type MSEG-DMBTR .
  methods SET_DMBTR
    importing
      !IV_DMBTR type MSEG-DMBTR .
  methods GET_BNBTR
    returning
      value(RESULT) type MSEG-BNBTR .
  methods SET_BNBTR
    importing
      !IV_BNBTR type MSEG-BNBTR .
  methods GET_BUALT
    returning
      value(RESULT) type MSEG-BUALT .
  methods SET_BUALT
    importing
      !IV_BUALT type MSEG-BUALT .
  methods GET_SHKUM
    returning
      value(RESULT) type MSEG-SHKUM .
  methods SET_SHKUM
    importing
      !IV_SHKUM type MSEG-SHKUM .
  methods GET_DMBUM
    returning
      value(RESULT) type MSEG-DMBUM .
  methods SET_DMBUM
    importing
      !IV_DMBUM type MSEG-DMBUM .
  methods GET_BWTAR
    returning
      value(RESULT) type MSEG-BWTAR .
  methods SET_BWTAR
    importing
      !IV_BWTAR type MSEG-BWTAR .
  methods GET_MENGE
    returning
      value(RESULT) type MSEG-MENGE .
  methods SET_MENGE
    importing
      !IV_MENGE type MSEG-MENGE .
  methods GET_MEINS
    returning
      value(RESULT) type MSEG-MEINS .
  methods SET_MEINS
    importing
      !IV_MEINS type MSEG-MEINS .
  methods GET_ERFMG
    returning
      value(RESULT) type MSEG-ERFMG .
  methods SET_ERFMG
    importing
      !IV_ERFMG type MSEG-ERFMG .
  methods GET_ERFME
    returning
      value(RESULT) type MSEG-ERFME .
  methods SET_ERFME
    importing
      !IV_ERFME type MSEG-ERFME .
  methods GET_BPMNG
    returning
      value(RESULT) type MSEG-BPMNG .
  methods SET_BPMNG
    importing
      !IV_BPMNG type MSEG-BPMNG .
  methods GET_BPRME
    returning
      value(RESULT) type MSEG-BPRME .
  methods SET_BPRME
    importing
      !IV_BPRME type MSEG-BPRME .
  methods GET_EBELN
    returning
      value(RESULT) type MSEG-EBELN .
  methods SET_EBELN
    importing
      !IV_EBELN type MSEG-EBELN .
  methods GET_EBELP
    returning
      value(RESULT) type MSEG-EBELP .
  methods SET_EBELP
    importing
      !IV_EBELP type MSEG-EBELP .
  methods GET_LFBJA
    returning
      value(RESULT) type MSEG-LFBJA .
  methods SET_LFBJA
    importing
      !IV_LFBJA type MSEG-LFBJA .
  methods GET_LFBNR
    returning
      value(RESULT) type MSEG-LFBNR .
  methods SET_LFBNR
    importing
      !IV_LFBNR type MSEG-LFBNR .
  methods GET_LFPOS
    returning
      value(RESULT) type MSEG-LFPOS .
  methods SET_LFPOS
    importing
      !IV_LFPOS type MSEG-LFPOS .
  methods GET_SJAHR
    returning
      value(RESULT) type MSEG-SJAHR .
  methods SET_SJAHR
    importing
      !IV_SJAHR type MSEG-SJAHR .
  methods GET_SMBLN
    returning
      value(RESULT) type MSEG-SMBLN .
  methods SET_SMBLN
    importing
      !IV_SMBLN type MSEG-SMBLN .
  methods GET_SMBLP
    returning
      value(RESULT) type MSEG-SMBLP .
  methods SET_SMBLP
    importing
      !IV_SMBLP type MSEG-SMBLP .
  methods GET_ELIKZ
    returning
      value(RESULT) type MSEG-ELIKZ .
  methods SET_ELIKZ
    importing
      !IV_ELIKZ type MSEG-ELIKZ .
  methods GET_SGTXT
    returning
      value(RESULT) type MSEG-SGTXT .
  methods SET_SGTXT
    importing
      !IV_SGTXT type MSEG-SGTXT .
  methods GET_EQUNR
    returning
      value(RESULT) type MSEG-EQUNR .
  methods SET_EQUNR
    importing
      !IV_EQUNR type MSEG-EQUNR .
  methods GET_WEMPF
    returning
      value(RESULT) type MSEG-WEMPF .
  methods SET_WEMPF
    importing
      !IV_WEMPF type MSEG-WEMPF .
  methods GET_ABLAD
    returning
      value(RESULT) type MSEG-ABLAD .
  methods SET_ABLAD
    importing
      !IV_ABLAD type MSEG-ABLAD .
  methods GET_GSBER
    returning
      value(RESULT) type MSEG-GSBER .
  methods SET_GSBER
    importing
      !IV_GSBER type MSEG-GSBER .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /S4TAX/MATERIAL_DOC_SEGMENT IMPLEMENTATION.


  METHOD SET_LFPOS.
    me->struct-lfpos = iv_lfpos.
  ENDMETHOD.


  METHOD SET_LFBNR.
    me->struct-lfbnr = iv_lfbnr.
  ENDMETHOD.


  METHOD SET_LFBJA.
    me->struct-lfbja = iv_lfbja.
  ENDMETHOD.


  METHOD SET_KUNNR.
    me->struct-kunnr = iv_kunnr.
  ENDMETHOD.


  METHOD SET_KDPOS.
    me->struct-kdpos = iv_kdpos.
  ENDMETHOD.


  METHOD SET_KDEIN.
    me->struct-kdein = iv_kdein.
  ENDMETHOD.


  METHOD SET_KDAUF.
    me->struct-kdauf = iv_kdauf.
  ENDMETHOD.


  METHOD SET_INSMK.
    me->struct-insmk = iv_insmk.
  ENDMETHOD.


  METHOD SET_GSBER.
    me->struct-gsber = iv_gsber.
  ENDMETHOD.


  METHOD SET_ERFMG.
    me->struct-erfmg = iv_erfmg.
  ENDMETHOD.


  METHOD SET_ERFME.
    me->struct-erfme = iv_erfme.
  ENDMETHOD.


  METHOD SET_EQUNR.
    me->struct-equnr = iv_equnr.
  ENDMETHOD.


  METHOD SET_ELIKZ.
    me->struct-elikz = iv_elikz.
  ENDMETHOD.


  METHOD SET_EBELP.
    me->struct-ebelp = iv_ebelp.
  ENDMETHOD.


  METHOD SET_EBELN.
    me->struct-ebeln = iv_ebeln.
  ENDMETHOD.


  METHOD SET_DMBUM.
    me->struct-dmbum = iv_dmbum.
  ENDMETHOD.


  METHOD SET_DMBTR.
    me->struct-dmbtr = iv_dmbtr.
  ENDMETHOD.


  METHOD SET_CHARG.
    me->struct-charg = iv_charg.
  ENDMETHOD.


  METHOD SET_BWTAR.
    me->struct-bwtar = iv_bwtar.
  ENDMETHOD.


  METHOD SET_BWART.
    me->struct-bwart = iv_bwart.
  ENDMETHOD.


  METHOD SET_BUALT.
    me->struct-bualt = iv_bualt.
  ENDMETHOD.


  METHOD SET_BPRME.
    me->struct-bprme = iv_bprme.
  ENDMETHOD.


  METHOD SET_BPMNG.
    me->struct-bpmng = iv_bpmng.
  ENDMETHOD.


  METHOD SET_BNBTR.
    me->struct-bnbtr = iv_bnbtr.
  ENDMETHOD.


  METHOD SET_ABLAD.
    me->struct-ablad = iv_ablad.
  ENDMETHOD.


  METHOD SET_LGORT.
    me->struct-lgort = iv_lgort.
  ENDMETHOD.


  METHOD SET_ZUSTD.
    me->struct-zustd = iv_zustd.
  ENDMETHOD.


  METHOD SET_ZUSCH.
    me->struct-zusch = iv_zusch.
  ENDMETHOD.


  METHOD SET_ZEILE.
    me->struct-zeile = iv_zeile.
  ENDMETHOD.


  METHOD SET_XAUTO.
    me->struct-xauto = iv_xauto.
  ENDMETHOD.


  METHOD SET_WERKS.
    me->struct-werks = iv_werks.
  ENDMETHOD.


  METHOD SET_WEMPF.
    me->struct-wempf = iv_wempf.
  ENDMETHOD.


  METHOD SET_WAERS.
    me->struct-waers = iv_waers.
  ENDMETHOD.


  METHOD SET_SOBKZ.
    me->struct-sobkz = iv_sobkz.
  ENDMETHOD.


  METHOD SET_SMBLP.
    me->struct-smblp = iv_smblp.
  ENDMETHOD.


  METHOD SET_SMBLN.
    me->struct-smbln = iv_smbln.
  ENDMETHOD.


  METHOD SET_SJAHR.
    me->struct-sjahr = iv_sjahr.
  ENDMETHOD.


  METHOD SET_SHKZG.
    me->struct-shkzg = iv_shkzg.
  ENDMETHOD.


  METHOD SET_SHKUM.
    me->struct-shkum = iv_shkum.
  ENDMETHOD.


  METHOD SET_SGTXT.
    me->struct-sgtxt = iv_sgtxt.
  ENDMETHOD.


  METHOD SET_PLPLA.
    me->struct-plpla = iv_plpla.
  ENDMETHOD.


  METHOD SET_PARENT_ID.
    me->struct-parent_id = iv_parent_id.
  ENDMETHOD.


  METHOD SET_MJAHR.
    me->struct-mjahr = iv_mjahr.
  ENDMETHOD.


  METHOD SET_MENGE.
    me->struct-menge = iv_menge.
  ENDMETHOD.


  METHOD SET_MEINS.
    me->struct-meins = iv_meins.
  ENDMETHOD.


  METHOD SET_MBLNR.
    me->struct-mblnr = iv_mblnr.
  ENDMETHOD.


  METHOD SET_MATNR.
    me->struct-matnr = iv_matnr.
  ENDMETHOD.


  METHOD SET_MAA_URZEI.
    me->struct-maa_urzei = iv_maa_urzei.
  ENDMETHOD.


  METHOD SET_LINE_ID.
    me->struct-line_id = iv_line_id.
  ENDMETHOD.


  METHOD SET_LINE_DEPTH.
    me->struct-line_depth = iv_line_depth.
  ENDMETHOD.


  METHOD SET_LIFNR.
    me->struct-lifnr = iv_lifnr.
  ENDMETHOD.


  METHOD GET_LFPOS.
    result = me->struct-lfpos.
  ENDMETHOD.


  METHOD GET_LFBNR.
    result = me->struct-lfbnr.
  ENDMETHOD.


  METHOD GET_LFBJA.
    result = me->struct-lfbja.
  ENDMETHOD.


  METHOD GET_KUNNR.
    result = me->struct-kunnr.
  ENDMETHOD.


  METHOD GET_KDPOS.
    result = me->struct-kdpos.
  ENDMETHOD.


  METHOD GET_KDEIN.
    result = me->struct-kdein.
  ENDMETHOD.


  METHOD GET_KDAUF.
    result = me->struct-kdauf.
  ENDMETHOD.


  METHOD GET_INSMK.
    result = me->struct-insmk.
  ENDMETHOD.


  METHOD GET_GSBER.
    result = me->struct-gsber.
  ENDMETHOD.


  METHOD GET_ERFMG.
    result = me->struct-erfmg.
  ENDMETHOD.


  METHOD GET_ERFME.
    result = me->struct-erfme.
  ENDMETHOD.


  METHOD GET_EQUNR.
    result = me->struct-equnr.
  ENDMETHOD.


  METHOD GET_ELIKZ.
    result = me->struct-elikz.
  ENDMETHOD.


  METHOD GET_EBELP.
    result = me->struct-ebelp.
  ENDMETHOD.


  METHOD GET_EBELN.
    result = me->struct-ebeln.
  ENDMETHOD.


  METHOD GET_DMBUM.
    result = me->struct-dmbum.
  ENDMETHOD.


  METHOD GET_DMBTR.
    result = me->struct-dmbtr.
  ENDMETHOD.


  METHOD GET_CHARG.
    result = me->struct-charg.
  ENDMETHOD.


  METHOD GET_BWTAR.
    result = me->struct-bwtar.
  ENDMETHOD.


  METHOD GET_BWART.
    result = me->struct-bwart.
  ENDMETHOD.


  METHOD GET_BUALT.
    result = me->struct-bualt.
  ENDMETHOD.


  METHOD GET_BPRME.
    result = me->struct-bprme.
  ENDMETHOD.


  METHOD GET_BPMNG.
    result = me->struct-bpmng.
  ENDMETHOD.


  METHOD GET_BNBTR.
    result = me->struct-bnbtr.
  ENDMETHOD.


  METHOD GET_ABLAD.
    result = me->struct-ablad.
  ENDMETHOD.


  METHOD GET_LGORT.
    result = me->struct-lgort.
  ENDMETHOD.


  METHOD GET_ZUSTD.
    result = me->struct-zustd.
  ENDMETHOD.


  METHOD GET_ZUSCH.
    result = me->struct-zusch.
  ENDMETHOD.


  METHOD GET_ZEILE.
    result = me->struct-zeile.
  ENDMETHOD.


  METHOD GET_XAUTO.
    result = me->struct-xauto.
  ENDMETHOD.


  METHOD GET_WERKS.
    result = me->struct-werks.
  ENDMETHOD.


  METHOD GET_WEMPF.
    result = me->struct-wempf.
  ENDMETHOD.


  METHOD GET_WAERS.
    result = me->struct-waers.
  ENDMETHOD.


  METHOD GET_SOBKZ.
    result = me->struct-sobkz.
  ENDMETHOD.


  METHOD GET_SMBLP.
    result = me->struct-smblp.
  ENDMETHOD.


  METHOD GET_SMBLN.
    result = me->struct-smbln.
  ENDMETHOD.


  METHOD GET_SJAHR.
    result = me->struct-sjahr.
  ENDMETHOD.


  METHOD GET_SHKZG.
    result = me->struct-shkzg.
  ENDMETHOD.


  METHOD GET_SHKUM.
    result = me->struct-shkum.
  ENDMETHOD.


  METHOD GET_SGTXT.
    result = me->struct-sgtxt.
  ENDMETHOD.


  METHOD GET_PLPLA.
    result = me->struct-plpla.
  ENDMETHOD.


  METHOD GET_PARENT_ID.
    result = me->struct-parent_id.
  ENDMETHOD.


  METHOD GET_MJAHR.
    result = me->struct-mjahr.
  ENDMETHOD.


  METHOD GET_MENGE.
    result = me->struct-menge.
  ENDMETHOD.


  METHOD GET_MEINS.
    result = me->struct-meins.
  ENDMETHOD.


  METHOD GET_MBLNR.
    result = me->struct-mblnr.
  ENDMETHOD.


  METHOD GET_MATNR.
    result = me->struct-matnr.
  ENDMETHOD.


  METHOD GET_MAA_URZEI.
    result = me->struct-maa_urzei.
  ENDMETHOD.


  METHOD GET_LINE_ID.
    result = me->struct-line_id.
  ENDMETHOD.


  METHOD GET_LINE_DEPTH.
    result = me->struct-line_depth.
  ENDMETHOD.


  METHOD GET_LIFNR.
    result = me->struct-lifnr.
  ENDMETHOD.
ENDCLASS.

CLASS /s4tax/model_mkpf DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: struct TYPE mkpf READ-ONLY.
    METHODS: get_mblnr
      RETURNING VALUE(result) TYPE mkpf-mblnr.


    METHODS: set_mblnr
      IMPORTING iv_mblnr TYPE mkpf-mblnr.


    METHODS: get_mjahr
      RETURNING VALUE(result) TYPE mkpf-mjahr.


    METHODS: set_mjahr
      IMPORTING iv_mjahr TYPE mkpf-mjahr.


    METHODS: get_vgart
      RETURNING VALUE(result) TYPE mkpf-vgart.


    METHODS: set_vgart
      IMPORTING iv_vgart TYPE mkpf-vgart.


    METHODS: get_blart
      RETURNING VALUE(result) TYPE mkpf-blart.


    METHODS: set_blart
      IMPORTING iv_blart TYPE mkpf-blart.


    METHODS: get_blaum
      RETURNING VALUE(result) TYPE mkpf-blaum.


    METHODS: set_blaum
      IMPORTING iv_blaum TYPE mkpf-blaum.


    METHODS: get_bldat
      RETURNING VALUE(result) TYPE mkpf-bldat.


    METHODS: set_bldat
      IMPORTING iv_bldat TYPE mkpf-bldat.


    METHODS: get_budat
      RETURNING VALUE(result) TYPE mkpf-budat.


    METHODS: set_budat
      IMPORTING iv_budat TYPE mkpf-budat.


    METHODS: get_cpudt
      RETURNING VALUE(result) TYPE mkpf-cpudt.


    METHODS: set_cpudt
      IMPORTING iv_cpudt TYPE mkpf-cpudt.


    METHODS: get_cputm
      RETURNING VALUE(result) TYPE mkpf-cputm.


    METHODS: set_cputm
      IMPORTING iv_cputm TYPE mkpf-cputm.


    METHODS: get_aedat
      RETURNING VALUE(result) TYPE mkpf-aedat.


    METHODS: set_aedat
      IMPORTING iv_aedat TYPE mkpf-aedat.


    METHODS: get_usnam
      RETURNING VALUE(result) TYPE mkpf-usnam.


    METHODS: set_usnam
      IMPORTING iv_usnam TYPE mkpf-usnam.


    METHODS: get_tcode
      RETURNING VALUE(result) TYPE mkpf-tcode.


    METHODS: set_tcode
      IMPORTING iv_tcode TYPE mkpf-tcode.


    METHODS: get_xblnr
      RETURNING VALUE(result) TYPE mkpf-xblnr.


    METHODS: set_xblnr
      IMPORTING iv_xblnr TYPE mkpf-xblnr.


    METHODS: get_bktxt
      RETURNING VALUE(result) TYPE mkpf-bktxt.


    METHODS: set_bktxt
      IMPORTING iv_bktxt TYPE mkpf-bktxt.


    METHODS: get_frath
      RETURNING VALUE(result) TYPE mkpf-frath.


    METHODS: set_frath
      IMPORTING iv_frath TYPE mkpf-frath.


    METHODS: get_frbnr
      RETURNING VALUE(result) TYPE mkpf-frbnr.


    METHODS: set_frbnr
      IMPORTING iv_frbnr TYPE mkpf-frbnr.


    METHODS: get_wever
      RETURNING VALUE(result) TYPE mkpf-wever.


    METHODS: set_wever
      IMPORTING iv_wever TYPE mkpf-wever.


    METHODS: get_xabln
      RETURNING VALUE(result) TYPE mkpf-xabln.


    METHODS: set_xabln
      IMPORTING iv_xabln TYPE mkpf-xabln.


    METHODS: get_awsys
      RETURNING VALUE(result) TYPE mkpf-awsys.


    METHODS: set_awsys
      IMPORTING iv_awsys TYPE mkpf-awsys.


    METHODS: get_bla2d
      RETURNING VALUE(result) TYPE mkpf-bla2d.


    METHODS: set_bla2d
      IMPORTING iv_bla2d TYPE mkpf-bla2d.


    METHODS: get_tcode2
      RETURNING VALUE(result) TYPE mkpf-tcode2.


    METHODS: set_tcode2
      IMPORTING iv_tcode2 TYPE mkpf-tcode2.


    METHODS: get_bfwms
      RETURNING VALUE(result) TYPE mkpf-bfwms.


    METHODS: set_bfwms
      IMPORTING iv_bfwms TYPE mkpf-bfwms.


    METHODS: get_exnum
      RETURNING VALUE(result) TYPE mkpf-exnum.


    METHODS: set_exnum
      IMPORTING iv_exnum TYPE mkpf-exnum.


    METHODS: get_spe_budat_uhr
      RETURNING VALUE(result) TYPE mkpf-spe_budat_uhr.


    METHODS: set_spe_budat_uhr
      IMPORTING iv_spe_budat_uhr TYPE mkpf-spe_budat_uhr.


    METHODS: get_spe_budat_zone
      RETURNING VALUE(result) TYPE mkpf-spe_budat_zone.


    METHODS: set_spe_budat_zone
      IMPORTING iv_spe_budat_zone TYPE mkpf-spe_budat_zone.


    METHODS: get_le_vbeln
      RETURNING VALUE(result) TYPE mkpf-le_vbeln.


    METHODS: set_le_vbeln
      IMPORTING iv_le_vbeln TYPE mkpf-le_vbeln.


    METHODS: get_spe_logsys
      RETURNING VALUE(result) TYPE mkpf-spe_logsys.


    METHODS: set_spe_logsys
      IMPORTING iv_spe_logsys TYPE mkpf-spe_logsys.


    METHODS: get_spe_mdnum_ewm
      RETURNING VALUE(result) TYPE mkpf-spe_mdnum_ewm.


    METHODS: set_spe_mdnum_ewm
      IMPORTING iv_spe_mdnum_ewm TYPE mkpf-spe_mdnum_ewm.


    METHODS: get_gts_cusref_no
      RETURNING VALUE(result) TYPE mkpf-gts_cusref_no.


    METHODS: set_gts_cusref_no
      IMPORTING iv_gts_cusref_no TYPE mkpf-gts_cusref_no.


    METHODS: get_fls_rsto
      RETURNING VALUE(result) TYPE mkpf-fls_rsto.


    METHODS: set_fls_rsto
      IMPORTING iv_fls_rsto TYPE mkpf-fls_rsto.


    METHODS: get_msr_active
      RETURNING VALUE(result) TYPE mkpf-msr_active.


    METHODS: set_msr_active
      IMPORTING iv_msr_active TYPE mkpf-msr_active.


    METHODS: get_knumv
      RETURNING VALUE(result) TYPE mkpf-knumv.


    METHODS: set_knumv
      IMPORTING iv_knumv TYPE mkpf-knumv.


    METHODS: get_xcompl
      RETURNING VALUE(result) TYPE mkpf-xcompl.


    METHODS: set_xcompl
      IMPORTING iv_xcompl TYPE mkpf-xcompl.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /s4tax/model_mkpf IMPLEMENTATION.
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


  METHOD get_vgart.
    result = me->struct-vgart.
  ENDMETHOD.


  METHOD set_vgart.
    me->struct-vgart = iv_vgart.
  ENDMETHOD.


  METHOD get_blart.
    result = me->struct-blart.
  ENDMETHOD.


  METHOD set_blart.
    me->struct-blart = iv_blart.
  ENDMETHOD.


  METHOD get_blaum.
    result = me->struct-blaum.
  ENDMETHOD.


  METHOD set_blaum.
    me->struct-blaum = iv_blaum.
  ENDMETHOD.


  METHOD get_bldat.
    result = me->struct-bldat.
  ENDMETHOD.


  METHOD set_bldat.
    me->struct-bldat = iv_bldat.
  ENDMETHOD.


  METHOD get_budat.
    result = me->struct-budat.
  ENDMETHOD.


  METHOD set_budat.
    me->struct-budat = iv_budat.
  ENDMETHOD.


  METHOD get_cpudt.
    result = me->struct-cpudt.
  ENDMETHOD.


  METHOD set_cpudt.
    me->struct-cpudt = iv_cpudt.
  ENDMETHOD.


  METHOD get_cputm.
    result = me->struct-cputm.
  ENDMETHOD.


  METHOD set_cputm.
    me->struct-cputm = iv_cputm.
  ENDMETHOD.


  METHOD get_aedat.
    result = me->struct-aedat.
  ENDMETHOD.


  METHOD set_aedat.
    me->struct-aedat = iv_aedat.
  ENDMETHOD.


  METHOD get_usnam.
    result = me->struct-usnam.
  ENDMETHOD.


  METHOD set_usnam.
    me->struct-usnam = iv_usnam.
  ENDMETHOD.


  METHOD get_tcode.
    result = me->struct-tcode.
  ENDMETHOD.


  METHOD set_tcode.
    me->struct-tcode = iv_tcode.
  ENDMETHOD.


  METHOD get_xblnr.
    result = me->struct-xblnr.
  ENDMETHOD.


  METHOD set_xblnr.
    me->struct-xblnr = iv_xblnr.
  ENDMETHOD.


  METHOD get_bktxt.
    result = me->struct-bktxt.
  ENDMETHOD.


  METHOD set_bktxt.
    me->struct-bktxt = iv_bktxt.
  ENDMETHOD.


  METHOD get_frath.
    result = me->struct-frath.
  ENDMETHOD.


  METHOD set_frath.
    me->struct-frath = iv_frath.
  ENDMETHOD.


  METHOD get_frbnr.
    result = me->struct-frbnr.
  ENDMETHOD.


  METHOD set_frbnr.
    me->struct-frbnr = iv_frbnr.
  ENDMETHOD.


  METHOD get_wever.
    result = me->struct-wever.
  ENDMETHOD.


  METHOD set_wever.
    me->struct-wever = iv_wever.
  ENDMETHOD.


  METHOD get_xabln.
    result = me->struct-xabln.
  ENDMETHOD.


  METHOD set_xabln.
    me->struct-xabln = iv_xabln.
  ENDMETHOD.


  METHOD get_awsys.
    result = me->struct-awsys.
  ENDMETHOD.


  METHOD set_awsys.
    me->struct-awsys = iv_awsys.
  ENDMETHOD.


  METHOD get_bla2d.
    result = me->struct-bla2d.
  ENDMETHOD.


  METHOD set_bla2d.
    me->struct-bla2d = iv_bla2d.
  ENDMETHOD.


  METHOD get_tcode2.
    result = me->struct-tcode2.
  ENDMETHOD.


  METHOD set_tcode2.
    me->struct-tcode2 = iv_tcode2.
  ENDMETHOD.


  METHOD get_bfwms.
    result = me->struct-bfwms.
  ENDMETHOD.


  METHOD set_bfwms.
    me->struct-bfwms = iv_bfwms.
  ENDMETHOD.


  METHOD get_exnum.
    result = me->struct-exnum.
  ENDMETHOD.


  METHOD set_exnum.
    me->struct-exnum = iv_exnum.
  ENDMETHOD.


  METHOD get_spe_budat_uhr.
    result = me->struct-spe_budat_uhr.
  ENDMETHOD.


  METHOD set_spe_budat_uhr.
    me->struct-spe_budat_uhr = iv_spe_budat_uhr.
  ENDMETHOD.


  METHOD get_spe_budat_zone.
    result = me->struct-spe_budat_zone.
  ENDMETHOD.


  METHOD set_spe_budat_zone.
    me->struct-spe_budat_zone = iv_spe_budat_zone.
  ENDMETHOD.


  METHOD get_le_vbeln.
    result = me->struct-le_vbeln.
  ENDMETHOD.


  METHOD set_le_vbeln.
    me->struct-le_vbeln = iv_le_vbeln.
  ENDMETHOD.


  METHOD get_spe_logsys.
    result = me->struct-spe_logsys.
  ENDMETHOD.


  METHOD set_spe_logsys.
    me->struct-spe_logsys = iv_spe_logsys.
  ENDMETHOD.


  METHOD get_spe_mdnum_ewm.
    result = me->struct-spe_mdnum_ewm.
  ENDMETHOD.


  METHOD set_spe_mdnum_ewm.
    me->struct-spe_mdnum_ewm = iv_spe_mdnum_ewm.
  ENDMETHOD.


  METHOD get_gts_cusref_no.
    result = me->struct-gts_cusref_no.
  ENDMETHOD.


  METHOD set_gts_cusref_no.
    me->struct-gts_cusref_no = iv_gts_cusref_no.
  ENDMETHOD.


  METHOD get_fls_rsto.
    result = me->struct-fls_rsto.
  ENDMETHOD.


  METHOD set_fls_rsto.
    me->struct-fls_rsto = iv_fls_rsto.
  ENDMETHOD.


  METHOD get_msr_active.
    result = me->struct-msr_active.
  ENDMETHOD.


  METHOD set_msr_active.
    me->struct-msr_active = iv_msr_active.
  ENDMETHOD.


  METHOD get_knumv.
    result = me->struct-knumv.
  ENDMETHOD.


  METHOD set_knumv.
    me->struct-knumv = iv_knumv.
  ENDMETHOD.


  METHOD get_xcompl.
    result = me->struct-xcompl.
  ENDMETHOD.


  METHOD set_xcompl.
    me->struct-xcompl = iv_xcompl.
  ENDMETHOD.
ENDCLASS.

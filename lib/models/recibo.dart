class Recibo {
  int idrecibo = 0;
  String grupo = '';
  String causante = '';
  int mes = 0;
  int anio = 0;
  String? link = '';
  int? firmado = 0;
  String? fechacarga = '';
  String? estadoRecibo = '';
  String? fechaestado = '';
  int? hsestado = 0;
  String? observaciones;
  String? imei = '';
  String? fechafirmaelectronica = '';
  int? hsfirmaelectronica = 0;
  String? latfirmaelectronica = '';
  String? longfirmaelectronica = '';
  String? periodoCalcNomina = '';
  String? nroSecuencia = '';
  String? periodo = '';
  String? pdfFromExcel = '';
  String? fechaPagoExcel = '';
  String? fechaIniExcel = '';
  String? fechaFinExcel = '';

  Recibo({
    required this.idrecibo,
    required this.grupo,
    required this.causante,
    required this.mes,
    required this.anio,
    required this.link,
    required this.firmado,
    required this.fechacarga,
    required this.estadoRecibo,
    required this.fechaestado,
    required this.hsestado,
    required this.observaciones,
    required this.imei,
    required this.fechafirmaelectronica,
    required this.hsfirmaelectronica,
    required this.latfirmaelectronica,
    required this.longfirmaelectronica,
    required this.periodoCalcNomina,
    required this.nroSecuencia,
    required this.periodo,
    required this.pdfFromExcel,
    required this.fechaPagoExcel,
    required this.fechaIniExcel,
    required this.fechaFinExcel,
  });

  Recibo.fromJson(Map<String, dynamic> json) {
    idrecibo = json['idrecibo'];
    grupo = json['grupo'];
    causante = json['causante'];
    mes = json['mes'];
    anio = json['anio'];
    link = json['link'];
    firmado = json['firmado'];
    fechacarga = json['fechacarga'];
    estadoRecibo = json['estadoRecibo'];
    fechaestado = json['fechaestado'];
    hsestado = json['hsestado'];
    observaciones = json['observaciones'];
    imei = json['imei'];
    fechafirmaelectronica = json['fechafirmaelectronica'];
    hsfirmaelectronica = json['hsfirmaelectronica'];
    latfirmaelectronica = json['latfirmaelectronica'];
    longfirmaelectronica = json['longfirmaelectronica'];
    periodoCalcNomina = json['periodoCalcNomina'];
    nroSecuencia = json['nroSecuencia'];
    periodo = json['periodo'];
    pdfFromExcel = json['pdfFromExcel'];
    fechaPagoExcel = json['fechaPagoExcel'];
    fechaIniExcel = json['fechaIniExcel'];
    fechaFinExcel = json['fechaFinExcel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idrecibo'] = idrecibo;
    data['grupo'] = grupo;
    data['causante'] = causante;
    data['mes'] = mes;
    data['anio'] = anio;
    data['link'] = link;
    data['firmado'] = firmado;
    data['fechacarga'] = fechacarga;
    data['estadoRecibo'] = estadoRecibo;
    data['fechaestado'] = fechaestado;
    data['hsestado'] = hsestado;
    data['observaciones'] = observaciones;
    data['direimeiccion'] = imei;
    data['fechafirmaelectronica'] = fechafirmaelectronica;
    data['hsfirmaelectronica'] = hsfirmaelectronica;
    data['latfirmaelectronica'] = latfirmaelectronica;
    data['longfirmaelectronica'] = longfirmaelectronica;
    data['periodoCalcNomina'] = periodoCalcNomina;
    data['nroSecuencia'] = nroSecuencia;
    data['periodo'] = periodo;
    data['pdfFromExcel'] = pdfFromExcel;
    data['fechaPagoExcel'] = fechaPagoExcel;
    data['fechaIniExcel'] = fechaIniExcel;
    data['fechaFinExcel'] = fechaFinExcel;

    return data;
  }
}

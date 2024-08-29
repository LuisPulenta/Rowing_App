class Mediacion {
  int idmediacion = 0;
  int idcausantejuicio = 0;
  String? mediadores = '';
  String? fecha = '';
  String? abogado = '';
  int? idcontraparte = 0;
  String? moneda = '';
  double? ofrecimiento = 0;
  String? tipotransaccion = '';
  String? condicionpago = '';
  String? vencimientooferta = '';
  String? resultadooferta = '';
  double? montocontraoferta = 0;
  String? aceptacioncontraoferta = '';
  String? linkarchivomediacion = '';
  String? linkarchivomediacionFullPath = '';

  Mediacion(
      {required this.idmediacion,
      required this.idcausantejuicio,
      required this.mediadores,
      required this.fecha,
      required this.abogado,
      required this.idcontraparte,
      required this.moneda,
      required this.ofrecimiento,
      required this.tipotransaccion,
      required this.condicionpago,
      required this.vencimientooferta,
      required this.resultadooferta,
      required this.montocontraoferta,
      required this.aceptacioncontraoferta,
      required this.linkarchivomediacion,
      required this.linkarchivomediacionFullPath});

  Mediacion.fromJson(Map<String, dynamic> json) {
    idmediacion = json['idmediacion'];
    idcausantejuicio = json['idcausantejuicio'];
    mediadores = json['mediadores'];
    fecha = json['fecha'];
    abogado = json['abogado'];
    idcontraparte = json['idcontraparte'];
    moneda = json['moneda'];
    ofrecimiento = json['ofrecimiento'];
    tipotransaccion = json['tipotransaccion'];
    condicionpago = json['condicionpago'];
    vencimientooferta = json['vencimientooferta'];
    resultadooferta = json['resultadooferta'];
    montocontraoferta = json['montocontraoferta'];
    aceptacioncontraoferta = json['aceptacioncontraoferta'];
    linkarchivomediacion = json['linkarchivomediacion'];
    linkarchivomediacionFullPath = json['linkarchivomediacionFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idmediacion'] = idmediacion;
    data['idcausantejuicio'] = idcausantejuicio;
    data['mediadores'] = mediadores;
    data['fecha'] = fecha;
    data['abogado'] = abogado;
    data['idcontraparte'] = idcontraparte;
    data['moneda'] = moneda;
    data['ofrecimiento'] = ofrecimiento;
    data['tipotransaccion'] = tipotransaccion;
    data['condicionpago'] = condicionpago;
    data['vencimientooferta'] = vencimientooferta;
    data['resultadooferta'] = resultadooferta;
    data['montocontraoferta'] = montocontraoferta;
    data['aceptacioncontraoferta'] = aceptacioncontraoferta;
    data['linkarchivomediacion'] = linkarchivomediacion;
    data['linkarchivomediacionFullPath'] = linkarchivomediacionFullPath;
    return data;
  }
}

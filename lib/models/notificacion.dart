class Notificacion {
  int idnotificacion = 0;
  int? idjuicio = 0;
  String? fechacarga = '';
  String? tipo = '';
  String? titulo = '';
  String? observaciones = '';
  String? moneda = '';
  double? monto = 0;
  String? tipotransaccion = '';
  String? condicionpago = '';
  String? nrofactura = '';
  String? lugar = '';
  String? participantes = '';
  String? fechaecho = '';
  String? fechavencimiento = '';
  String? linkarchivo = '';
  String? linkarchivoFullPath = '';

  Notificacion(
      {required this.idnotificacion,
      required this.idjuicio,
      required this.fechacarga,
      required this.tipo,
      required this.titulo,
      required this.observaciones,
      required this.moneda,
      required this.monto,
      required this.tipotransaccion,
      required this.condicionpago,
      required this.nrofactura,
      required this.lugar,
      required this.participantes,
      required this.fechaecho,
      required this.fechavencimiento,
      required this.linkarchivo,
      required this.linkarchivoFullPath});

  Notificacion.fromJson(Map<String, dynamic> json) {
    idnotificacion = json['idnotificacion'];
    idjuicio = json['idjuicio'];
    fechacarga = json['fechacarga'];
    tipo = json['tipo'];
    titulo = json['titulo'];
    observaciones = json['observaciones'];
    moneda = json['moneda'];
    monto = json['monto'];
    tipotransaccion = json['tipotransaccion'];
    condicionpago = json['condicionpago'];
    nrofactura = json['nrofactura'];
    lugar = json['lugar'];
    participantes = json['participantes'];
    fechaecho = json['fechaecho'];
    fechavencimiento = json['fechavencimiento'];
    linkarchivo = json['linkarchivo'];
    linkarchivoFullPath = json['linkarchivoFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idnotificacion'] = idnotificacion;
    data['idjuicio'] = idjuicio;
    data['fechacarga'] = fechacarga;
    data['tipo'] = tipo;
    data['titulo'] = titulo;
    data['observaciones'] = observaciones;
    data['moneda'] = moneda;
    data['monto'] = monto;
    data['tipotransaccion'] = tipotransaccion;
    data['condicionpago'] = condicionpago;
    data['nrofactura'] = nrofactura;
    data['lugar'] = lugar;
    data['participantes'] = participantes;
    data['fechaecho'] = fechaecho;
    data['fechavencimiento'] = fechavencimiento;
    data['linkarchivo'] = linkarchivo;
    data['linkarchivoFullPath'] = linkarchivoFullPath;
    return data;
  }
}

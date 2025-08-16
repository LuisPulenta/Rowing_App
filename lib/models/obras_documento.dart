class ObrasDocumento {
  int nroregistro = 0;
  int nroobra = 0;
  int? idObrasPostes = 0;
  String? observacion = '';
  String? link = '';
  String? fecha = '';
  String? modulo = '';
  String? nroLote = '';
  String? sector = '';
  String? estante = '';
  String? generadoPor = '';
  double? latitud = 0.0;
  double? longitud = 0.0;
  String? fechaHsFoto = '';
  int? tipoDeFoto = 0;
  String? direccionFoto = '';
  String? imageFullPath = '';

  ObrasDocumento(
      {required this.nroregistro,
      required this.nroobra,
      required this.idObrasPostes,
      required this.observacion,
      required this.link,
      required this.fecha,
      required this.modulo,
      required this.nroLote,
      required this.sector,
      required this.estante,
      required this.generadoPor,
      required this.latitud,
      required this.longitud,
      required this.fechaHsFoto,
      required this.tipoDeFoto,
      required this.direccionFoto,
      required this.imageFullPath});

  ObrasDocumento.fromJson(Map<String, dynamic> json) {
    nroregistro = json['nroregistro'];
    nroobra = json['nroobra'];
    idObrasPostes = json['idObrasPostes'];
    observacion = json['observacion'];
    link = json['link'];
    fecha = json['fecha'];
    modulo = json['modulo'];
    nroLote = json['nroLote'];
    sector = json['sector'];
    estante = json['estante'];
    generadoPor = json['generadoPor'];
    latitud = json['latitud'] != null ? json['latitud'].toDouble() : 0.0;
    longitud = json['longitud'] != null ? json['longitud'].toDouble() : 0.0;
    fechaHsFoto = json['fechaHsFoto'];
    tipoDeFoto = json['tipoDeFoto'];
    direccionFoto = json['direccionFoto'];
    imageFullPath = json['imageFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroregistro'] = nroregistro;
    data['nroobra'] = nroobra;
    data['idObrasPostes'] = idObrasPostes;
    data['observacion'] = observacion;
    data['link'] = link;
    data['fecha'] = fecha;
    data['modulo'] = modulo;
    data['nroLote'] = nroLote;
    data['sector'] = sector;
    data['estante'] = estante;
    data['generadoPor'] = generadoPor;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['fechaHsFoto'] = fechaHsFoto;
    data['tipoDeFoto'] = tipoDeFoto;
    data['direccionFoto'] = direccionFoto;
    data['imageFullPath'] = imageFullPath;
    return data;
  }
}

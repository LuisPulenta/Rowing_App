class Movimiento {
  int nroMovimiento = 0;
  String? fechaCarga = '';
  String? codigoConcepto = '';
  String? codigoGrupo = '';
  String? codigoCausante = '';
  String? codigoGrupoRec = '';
  String? codigoCausanteRec = '';
  int? nroRemitoR = 0;
  String? docSAP = '';
  int? nroLote = 0;
  int? usrAlta = 0;
  String? linkRemito = '';
  String? imageFullPath = '';

  Movimiento(
      {required this.nroMovimiento,
      required this.fechaCarga,
      required this.codigoConcepto,
      required this.codigoGrupo,
      required this.codigoCausante,
      required this.codigoGrupoRec,
      required this.codigoCausanteRec,
      required this.nroRemitoR,
      required this.docSAP,
      required this.nroLote,
      required this.usrAlta,
      required this.linkRemito,
      required this.imageFullPath});

  Movimiento.fromJson(Map<String, dynamic> json) {
    nroMovimiento = json['nroMovimiento'];
    fechaCarga = json['fechaCarga'];
    codigoConcepto = json['codigoConcepto'];
    codigoGrupo = json['codigoGrupo'];
    codigoCausante = json['codigoCausante'];
    codigoGrupoRec = json['codigoGrupoRec'];
    codigoCausanteRec = json['codigoCausanteRec'];
    nroRemitoR = json['nroRemitoR'];
    docSAP = json['docSAP'];
    nroLote = json['nroLote'];
    usrAlta = json['usrAlta'];
    linkRemito = json['linkRemito'];
    imageFullPath = json['imageFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroMovimiento'] = nroMovimiento;
    data['fechaCarga'] = fechaCarga;
    data['codigoConcepto'] = codigoConcepto;
    data['codigoGrupo'] = codigoGrupo;
    data['codigoCausante'] = codigoCausante;
    data['codigoGrupoRec'] = codigoGrupoRec;
    data['codigoCausanteRec'] = codigoCausanteRec;
    data['nroRemitoR'] = nroRemitoR;
    data['docSAP'] = docSAP;
    data['nroLote'] = nroLote;
    data['usrAlta'] = usrAlta;
    data['linkRemito'] = linkRemito;
    data['imageFullPath'] = imageFullPath;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'nroMovimiento': nroMovimiento,
      'fechaCarga': fechaCarga,
      'codigoConcepto': codigoConcepto,
      'codigoGrupo': codigoGrupo,
      'codigoCausante': codigoCausante,
      'codigoGrupoRec': codigoGrupoRec,
      'codigoCausanteRec': codigoCausanteRec,
      'nroRemitoR': nroRemitoR,
      'docSAP': docSAP,
      'nroLote': nroLote,
      'usrAlta': usrAlta,
      'linkRemito': linkRemito,
      'imageFullPath': imageFullPath,
    };
  }
}

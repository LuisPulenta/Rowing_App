class Catalogo {
  String? catCodigo = '';
  String? codigoSap = '';
  String? catCatalogo = '';
  int? verEnReclamosApp = 0;
  int? verRequerimientosAPP = 0;
  int? verRequerimientosEPP = 0;
  int? verEnSuministros = 0;
  int? verEnCalle = 0;
  String? modulo = '';
  double? cantidad = 0.0;
  double? cantidad2 = 0.0;

  Catalogo(
      {required this.catCodigo,
      required this.codigoSap,
      required this.catCatalogo,
      required this.verEnReclamosApp,
      required this.verRequerimientosAPP,
      required this.verRequerimientosEPP,
      required this.verEnSuministros,
      required this.verEnCalle,
      required this.modulo,
      required this.cantidad,
      required this.cantidad2});

  Catalogo.fromJson(Map<String, dynamic> json) {
    catCodigo = json['catCodigo'];
    codigoSap = json['codigoSap'];
    catCatalogo = json['catCatalogo'];
    verEnReclamosApp = json['verEnReclamosApp'];
    verRequerimientosAPP = json['verRequerimientosAPP'];
    verRequerimientosEPP = json['verRequerimientosEPP'];
    verEnSuministros = json['verEnSuministros'];
    verEnCalle = json['verEnCalle'];
    modulo = json['modulo'];
    cantidad = json['cantidad'];
    cantidad2 = json['cantidad2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catCodigo'] = catCodigo;
    data['codigoSap'] = codigoSap;
    data['catCatalogo'] = catCatalogo;
    data['verEnReclamosApp'] = verEnReclamosApp;
    data['verRequerimientosAPP'] = verRequerimientosAPP;
    data['verRequerimientosEPP'] = verRequerimientosEPP;
    data['verEnSuministros'] = verEnSuministros;
    data['verEnCalle'] = verEnCalle;
    data['modulo'] = modulo;
    data['cantidad'] = cantidad;
    data['cantidad2'] = cantidad2;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'catCodigo': catCodigo,
      'codigoSap': codigoSap,
      'catCatalogo': catCatalogo,
      'verEnReclamosApp': verEnReclamosApp,
      'verRequerimientosAPP': verRequerimientosAPP,
      'verRequerimientosEPP': verRequerimientosEPP,
      'verEnSuministros': verEnSuministros,
      'verEnCalle': verEnCalle,
      'modulo': modulo,
      'cantidad': cantidad,
      'cantidad2': cantidad2,
    };
  }
}

class Catalogo {
  String? catCodigo = '';
  String? codigoSap = '';
  String? catCatalogo = '';
  int? verEnReclamosApp = 0;
  String? modulo = '';
  double? cantidad = 0.0;

  Catalogo(
      {required this.catCodigo,
      required this.codigoSap,
      required this.catCatalogo,
      required this.verEnReclamosApp,
      required this.modulo,
      required this.cantidad});

  Catalogo.fromJson(Map<String, dynamic> json) {
    catCodigo = json['catCodigo'];
    codigoSap = json['codigoSap'];
    catCatalogo = json['catCatalogo'];
    verEnReclamosApp = json['verEnReclamosApp'];
    modulo = json['modulo'];
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catCodigo'] = catCodigo;
    data['codigoSap'] = codigoSap;
    data['catCatalogo'] = catCatalogo;
    data['verEnReclamosApp'] = verEnReclamosApp;
    data['modulo'] = modulo;
    data['cantidad'] = cantidad;
    return data;
  }
}

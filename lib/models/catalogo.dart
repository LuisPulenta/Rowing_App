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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catCodigo'] = this.catCodigo;
    data['codigoSap'] = this.codigoSap;
    data['catCatalogo'] = this.catCatalogo;
    data['verEnReclamosApp'] = this.verEnReclamosApp;
    data['modulo'] = this.modulo;
    data['cantidad'] = this.cantidad;
    return data;
  }
}

class Subcontratista {
  String subCodigo = '';
  String subSubcontratista = '';
  String modulo = '';

  Subcontratista(
      {required this.subCodigo,
      required this.subSubcontratista,
      required this.modulo});

  Subcontratista.fromJson(Map<String, dynamic> json) {
    subCodigo = json['subCodigo'];
    subSubcontratista = json['subSubcontratista'];
    modulo = json['modulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subCodigo'] = subCodigo;
    data['subSubcontratista'] = subSubcontratista;
    data['modulo'] = modulo;
    return data;
  }
}

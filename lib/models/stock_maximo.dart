class StockMaximo {
  String id = '';
  String? grupoc = '';
  String? causante = '';
  String? codigosiag = '';
  String? codigosap = '';
  String? catCatalogo = '';
  double? maximo = 0.0;

  StockMaximo({
    required this.id,
    required this.grupoc,
    required this.causante,
    required this.codigosiag,
    required this.codigosap,
    required this.catCatalogo,
    required this.maximo,
  });

  StockMaximo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grupoc = json['grupoc'];
    causante = json['causante'];
    codigosiag = json['codigosiag'];
    codigosap = json['codigosap'];
    catCatalogo = json['catCatalogo'];
    maximo = json['maximo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['grupoc'] = grupoc;
    data['causante'] = causante;
    data['codigosiag'] = codigosiag;
    data['codigosap'] = codigosap;
    data['catCatalogo'] = catCatalogo;
    data['maximo'] = maximo;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'grupoc': grupoc,
      'causante': causante,
      'codigosiag': codigosiag,
      'codigosap': codigosap,
      'catCatalogo': catCatalogo,
      'maximo': maximo,
    };
  }
}

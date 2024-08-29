class CodigoProduccion {
  String codigo = '';
  String fechaminima = '';
  String fechamaxima = '';
  String qpostpermitido = '';
  String qantpermitido = '';

  CodigoProduccion({
    required this.codigo,
    required this.fechaminima,
    required this.fechamaxima,
    required this.qpostpermitido,
    required this.qantpermitido,
  });

  CodigoProduccion.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    fechaminima = json['fechaminima'];
    fechamaxima = json['fechamaxima'];
    qpostpermitido = json['qpostpermitido'];
    qantpermitido = json['qantpermitido'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codigo'] = codigo;
    data['fechaminima'] = fechaminima;
    data['fechamaxima'] = fechamaxima;
    data['qpostpermitido'] = qpostpermitido;
    data['qantpermitido'] = qantpermitido;
    return data;
  }
}

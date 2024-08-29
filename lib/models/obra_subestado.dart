class ObraSubestado {
  String codigosubestado = '';
  String codigoestado = '';
  String? descripcion = '';

  ObraSubestado(
      {required this.codigosubestado,
      required this.codigoestado,
      required this.descripcion});

  ObraSubestado.fromJson(Map<String, dynamic> json) {
    codigosubestado = json['codigosubestado'];
    codigoestado = json['codigoestado'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codigosubestado'] = codigosubestado;
    data['codigoestado'] = codigoestado;
    data['descripcion'] = descripcion;
    return data;
  }
}

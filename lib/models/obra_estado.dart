class ObraEstado {
  String codigo = '';
  String? descripcion = '';

  ObraEstado({required this.codigo, required this.descripcion});

  ObraEstado.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codigo'] = codigo;
    data['descripcion'] = descripcion;
    return data;
  }
}

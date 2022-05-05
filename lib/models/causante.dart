class Causante {
  int nroCausante = 0;
  String codigo = '';
  String nombre = '';
  String encargado = '';
  String? telefono = '';
  String grupo = '';
  String nroSAP = '';
  bool estado = false;

  Causante(
      {required this.nroCausante,
      required this.codigo,
      required this.nombre,
      required this.encargado,
      required this.telefono,
      required this.grupo,
      required this.nroSAP,
      required this.estado});

  Causante.fromJson(Map<String, dynamic> json) {
    nroCausante = json['nroCausante'];
    codigo = json['codigo'];
    nombre = json['nombre'];
    encargado = json['encargado'];
    telefono = json['telefono'];
    grupo = json['grupo'];
    nroSAP = json['nroSAP'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nroCausante'] = this.nroCausante;
    data['codigo'] = this.codigo;
    data['nombre'] = this.nombre;
    data['encargado'] = this.encargado;
    data['telefono'] = this.telefono;
    data['grupo'] = this.grupo;
    data['nroSAP'] = this.nroSAP;
    data['estado'] = this.estado;
    return data;
  }
}

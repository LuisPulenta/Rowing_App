class CausanteObra {
  int nroCausante = 0;
  String grupo = '';
  String codigo = '';
  String nombre = '';
  bool? estado = false;

  CausanteObra({
    required this.nroCausante,
    required this.grupo,
    required this.codigo,
    required this.nombre,
    required this.estado,
  });

  CausanteObra.fromJson(Map<String, dynamic> json) {
    nroCausante = json['nroCausante'];
    grupo = json['grupo'];
    codigo = json['codigo'];
    nombre = json['nombre'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroCausante'] = nroCausante;
    data['codigo'] = codigo;
    data['grupo'] = grupo;
    data['nombre'] = nombre;
    data['estado'] = estado;
    return data;
  }
}

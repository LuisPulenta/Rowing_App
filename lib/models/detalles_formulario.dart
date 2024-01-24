class DetallesFormulario {
  int idcliente = 0;
  int idgrupoformulario = 0;
  String detallef = '';
  String descripcion = '';
  int ponderacionpuntos = 0;
  String? cumple = '';
  int soloTexto = 0;

  DetallesFormulario(
      {required this.idcliente,
      required this.idgrupoformulario,
      required this.detallef,
      required this.descripcion,
      required this.ponderacionpuntos,
      required this.cumple,
      required this.soloTexto});

  DetallesFormulario.fromJson(Map<String, dynamic> json) {
    idcliente = json['idcliente'];
    idgrupoformulario = json['idgrupoformulario'];
    detallef = json['detallef'];
    descripcion = json['descripcion'];
    ponderacionpuntos = json['ponderacionpuntos'];
    cumple = json['cumple'];
    soloTexto = json['soloTexto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idcliente'] = idcliente;
    data['idgrupoformulario'] = idgrupoformulario;
    data['detallef'] = detallef;
    data['descripcion'] = descripcion;
    data['ponderacionpuntos'] = ponderacionpuntos;
    data['cumple'] = cumple;
    data['soloTexto'] = soloTexto;
    return data;
  }
}

class DetallesFormulario {
  int idcliente = 0;
  int idgrupoformulario = 0;
  String detallef = '';
  String descripcion = '';
  int ponderacionpuntos = 0;
  String? cumple = '';

  DetallesFormulario(
      {required this.idcliente,
      required this.idgrupoformulario,
      required this.detallef,
      required this.descripcion,
      required this.ponderacionpuntos,
      required this.cumple});

  DetallesFormulario.fromJson(Map<String, dynamic> json) {
    idcliente = json['idcliente'];
    idgrupoformulario = json['idgrupoformulario'];
    detallef = json['detallef'];
    descripcion = json['descripcion'];
    ponderacionpuntos = json['ponderacionpuntos'];
    cumple = json['cumple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcliente'] = this.idcliente;
    data['idgrupoformulario'] = this.idgrupoformulario;
    data['detallef'] = this.detallef;
    data['descripcion'] = this.descripcion;
    data['ponderacionpuntos'] = this.ponderacionpuntos;
    data['cumple'] = this.cumple;
    return data;
  }
}

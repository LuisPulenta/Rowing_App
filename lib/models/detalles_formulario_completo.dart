class DetallesFormularioCompleto {
  int idcliente = 0;
  int idgrupoformulario = 0;
  String descgrupoformulario = '';
  String detallef = '';
  String descripcion = '';
  int ponderacionpuntos = 0;
  String? cumple = '';

  DetallesFormularioCompleto(
      {required this.idcliente,
      required this.idgrupoformulario,
      required this.descgrupoformulario,
      required this.detallef,
      required this.descripcion,
      required this.ponderacionpuntos,
      required this.cumple});

  DetallesFormularioCompleto.fromJson(Map<String, dynamic> json) {
    idcliente = json['idcliente'];
    idgrupoformulario = json['idgrupoformulario'];
    descgrupoformulario = json['descgrupoformulario'];
    detallef = json['detallef'];
    descripcion = json['descripcion'];
    ponderacionpuntos = json['ponderacionpuntos'];
    cumple = json['cumple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcliente'] = this.idcliente;
    data['idgrupoformulario'] = this.idgrupoformulario;
    data['descgrupoformulario'] = this.descgrupoformulario;
    data['detallef'] = this.detallef;
    data['descripcion'] = this.descripcion;
    data['ponderacionpuntos'] = this.ponderacionpuntos;
    data['cumple'] = this.cumple;
    return data;
  }

  factory DetallesFormularioCompleto.fromMap(Map<String, dynamic> json) =>
      DetallesFormularioCompleto(
        idcliente: json["idcliente"],
        idgrupoformulario: json["idgrupoformulario"],
        descgrupoformulario: json["descgrupoformulario"],
        detallef: json["detallef"],
        descripcion: json["descripcion"],
        ponderacionpuntos: json["ponderacionpuntos"],
        cumple: json["cumple"],
      );
}

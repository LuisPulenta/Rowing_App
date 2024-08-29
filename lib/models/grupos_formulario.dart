class GruposFormulario {
  int idcliente = 0;
  int idtipotrabajo = 0;
  int idgrupoformulario = 0;
  String descripcion = '';

  GruposFormulario(
      {required this.idcliente,
      required this.idtipotrabajo,
      required this.idgrupoformulario,
      required this.descripcion});

  GruposFormulario.fromJson(Map<String, dynamic> json) {
    idcliente = json['idcliente'];
    idtipotrabajo = json['idtipotrabajo'];
    idgrupoformulario = json['idgrupoformulario'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idcliente'] = idcliente;
    data['idtipotrabajo'] = idtipotrabajo;
    data['idgrupoformulario'] = idgrupoformulario;
    data['descripcion'] = descripcion;
    return data;
  }
}

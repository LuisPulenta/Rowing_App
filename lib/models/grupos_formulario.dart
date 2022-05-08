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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcliente'] = this.idcliente;
    data['idtipotrabajo'] = this.idtipotrabajo;
    data['idgrupoformulario'] = this.idgrupoformulario;
    data['descripcion'] = this.descripcion;
    return data;
  }
}

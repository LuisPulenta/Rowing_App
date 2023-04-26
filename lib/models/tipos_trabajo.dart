class TiposTrabajo {
  int idregistro = 0;
  int idtipotrabajo = 0;
  String descripcion = '';
  int idcliente = 0;

  TiposTrabajo(
      {required this.idregistro,
      required this.idtipotrabajo,
      required this.descripcion,
      required this.idcliente});

  TiposTrabajo.fromJson(Map<String, dynamic> json) {
    idregistro = json['idregistro'];
    idtipotrabajo = json['idtipotrabajo'];
    descripcion = json['descripcion'];
    idcliente = json['idcliente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idregistro'] = idregistro;
    data['idtipotrabajo'] = idtipotrabajo;
    data['descripcion'] = descripcion;
    data['idcliente'] = idcliente;
    return data;
  }
}

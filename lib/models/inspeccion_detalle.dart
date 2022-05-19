class InspeccionDetalle {
  int idRegistro = 0;
  int inspeccionCab = 0;
  int idCliente = 0;
  int idGrupoFormulario = 0;
  String detalleF = '';
  String descripcion = '';
  int ponderacionPuntos = 0;
  String cumple = '';
  String linkFoto = '';
  String imageFullPath = '';

  InspeccionDetalle(
      {required this.idRegistro,
      required this.inspeccionCab,
      required this.idCliente,
      required this.idGrupoFormulario,
      required this.detalleF,
      required this.descripcion,
      required this.ponderacionPuntos,
      required this.cumple,
      required this.linkFoto,
      required this.imageFullPath});

  InspeccionDetalle.fromJson(Map<String, dynamic> json) {
    idRegistro = json['idRegistro'];
    inspeccionCab = json['inspeccionCab'];
    idCliente = json['idCliente'];
    idGrupoFormulario = json['idGrupoFormulario'];
    detalleF = json['detalleF'];
    descripcion = json['descripcion'];
    ponderacionPuntos = json['ponderacionPuntos'];
    cumple = json['cumple'];
    linkFoto = json['linkFoto'];
    imageFullPath = json['imageFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idRegistro'] = this.idRegistro;
    data['inspeccionCab'] = this.inspeccionCab;
    data['idCliente'] = this.idCliente;
    data['idGrupoFormulario'] = this.idGrupoFormulario;
    data['detalleF'] = this.detalleF;
    data['descripcion'] = this.descripcion;
    data['ponderacionPuntos'] = this.ponderacionPuntos;
    data['cumple'] = this.cumple;
    data['linkFoto'] = this.linkFoto;
    data['imageFullPath'] = this.imageFullPath;
    return data;
  }
}

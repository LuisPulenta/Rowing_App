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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idRegistro'] = idRegistro;
    data['inspeccionCab'] = inspeccionCab;
    data['idCliente'] = idCliente;
    data['idGrupoFormulario'] = idGrupoFormulario;
    data['detalleF'] = detalleF;
    data['descripcion'] = descripcion;
    data['ponderacionPuntos'] = ponderacionPuntos;
    data['cumple'] = cumple;
    data['linkFoto'] = linkFoto;
    data['imageFullPath'] = imageFullPath;
    return data;
  }
}

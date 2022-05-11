class InspeccionDetalle {
  int iDRegistro = 0;
  int inspeccionCab = 0;
  int idCliente = 0;
  int iDGrupoFormulario = 0;
  String detalleF = '';
  String descripcion = '';
  int ponderacionPuntos = 0;
  String cumple = '';

  InspeccionDetalle(
      {required this.iDRegistro,
      required this.inspeccionCab,
      required this.idCliente,
      required this.iDGrupoFormulario,
      required this.detalleF,
      required this.descripcion,
      required this.ponderacionPuntos,
      required this.cumple});

  InspeccionDetalle.fromJson(Map<String, dynamic> json) {
    iDRegistro = json['iDRegistro'];
    inspeccionCab = json['inspeccionCab'];
    idCliente = json['idCliente'];
    iDGrupoFormulario = json['iDGrupoFormulario'];
    detalleF = json['detalleF'];
    descripcion = json['descripcion'];
    ponderacionPuntos = json['ponderacionPuntos'];
    cumple = json['cumple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iDRegistro'] = this.iDRegistro;
    data['inspeccionCab'] = this.inspeccionCab;
    data['idCliente'] = this.idCliente;
    data['iDGrupoFormulario'] = this.iDGrupoFormulario;
    data['detalleF'] = this.detalleF;
    data['descripcion'] = this.descripcion;
    data['ponderacionPuntos'] = this.ponderacionPuntos;
    data['cumple'] = this.cumple;
    return data;
  }
}

class VistaInspeccionesFoto {
  int idRegistro = 0;
  String linkFoto = '';
  int usuarioAlta = 0;
  String apellido = '';
  String nombre = '';
  String fecha = '';
  String causanteC = '';
  String grupoC = '';
  String causante = '';
  String descripcion = '';
  String cumple = '';
  String cliente = '';
  String imageFullPath = '';

  VistaInspeccionesFoto(
      {required this.idRegistro,
      required this.linkFoto,
      required this.usuarioAlta,
      required this.apellido,
      required this.nombre,
      required this.fecha,
      required this.causanteC,
      required this.grupoC,
      required this.causante,
      required this.descripcion,
      required this.cumple,
      required this.cliente,
      required this.imageFullPath});

  VistaInspeccionesFoto.fromJson(Map<String, dynamic> json) {
    idRegistro = json['idRegistro'];
    linkFoto = json['linkFoto'];
    usuarioAlta = json['usuarioAlta'];
    apellido = json['apellido'];
    nombre = json['nombre'];
    fecha = json['fecha'];
    causanteC = json['causanteC'];
    grupoC = json['grupoC'];
    causante = json['causante'];
    descripcion = json['descripcion'];
    cumple = json['cumple'];
    cliente = json['cliente'];
    imageFullPath = json['imageFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idRegistro'] = idRegistro;
    data['linkFoto'] = linkFoto;
    data['usuarioAlta'] = usuarioAlta;
    data['apellido'] = apellido;
    data['nombre'] = nombre;
    data['fecha'] = fecha;
    data['causanteC'] = causanteC;
    data['grupoC'] = grupoC;
    data['causante'] = causante;
    data['descripcion'] = descripcion;
    data['cumple'] = cumple;
    data['cliente'] = cliente;
    data['imageFullPath'] = imageFullPath;
    return data;
  }
}

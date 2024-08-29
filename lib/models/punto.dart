class Punto {
  int idgeo = 0;
  int idUsuario = 0;
  String usuarioStr = '';
  String latitud = '';
  String longitud = '';
  String pin = '';
  String posicionCalle = '';
  double velocidad = 0.0;
  double bateria = 0.0;
  String fecha = '';
  String modulo = '';
  int origen = 0;

  Punto(
      {required this.idgeo,
      required this.idUsuario,
      required this.usuarioStr,
      required this.latitud,
      required this.longitud,
      required this.pin,
      required this.posicionCalle,
      required this.velocidad,
      required this.bateria,
      required this.fecha,
      required this.modulo,
      required this.origen});

  Punto.fromJson(Map<String, dynamic> json) {
    idgeo = json['idgeo'];
    idUsuario = json['idUsuario'];
    usuarioStr = json['usuarioStr'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    pin = json['pin'];
    posicionCalle = json['posicionCalle'];
    velocidad = json['velocidad'];
    bateria = json['bateria'];
    fecha = json['fecha'];
    modulo = json['modulo'];
    origen = json['origen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idgeo'] = idgeo;
    data['idUsuario'] = idUsuario;
    data['usuarioStr'] = usuarioStr;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['pin'] = pin;
    data['posicionCalle'] = posicionCalle;
    data['velocidad'] = velocidad;
    data['bateria'] = bateria;
    data['fecha'] = fecha;
    data['modulo'] = modulo;
    data['origen'] = origen;
    return data;
  }
}

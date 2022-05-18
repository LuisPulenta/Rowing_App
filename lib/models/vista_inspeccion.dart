class VistaInspeccion {
  int usuarioAlta = 0;
  String fecha = '';
  String empleado = '';
  String cliente = '';
  String tipoTrabajo = '';
  String obra = '';
  int totalPreguntas = 0;
  int totalNo = 0;
  int puntos = 0;
  String? dniSR = '';
  String? nombreSR = '';

  VistaInspeccion(
      {required this.usuarioAlta,
      required this.fecha,
      required this.empleado,
      required this.cliente,
      required this.tipoTrabajo,
      required this.obra,
      required this.totalPreguntas,
      required this.totalNo,
      required this.puntos,
      required this.dniSR,
      required this.nombreSR});

  VistaInspeccion.fromJson(Map<String, dynamic> json) {
    usuarioAlta = json['usuarioAlta'];
    fecha = json['fecha'];
    empleado = json['empleado'];
    cliente = json['cliente'];
    tipoTrabajo = json['tipoTrabajo'];
    obra = json['obra'];
    totalPreguntas = json['totalPreguntas'];
    totalNo = json['totalNo'];
    puntos = json['puntos'];
    dniSR = json['dniSR'];
    nombreSR = json['nombreSR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usuarioAlta'] = this.usuarioAlta;
    data['fecha'] = this.fecha;
    data['empleado'] = this.empleado;
    data['cliente'] = this.cliente;
    data['tipoTrabajo'] = this.tipoTrabajo;
    data['obra'] = this.obra;
    data['totalPreguntas'] = this.totalPreguntas;
    data['totalNo'] = this.totalNo;
    data['puntos'] = this.puntos;
    data['dniSR'] = this.dniSR;
    data['nombreSR'] = this.nombreSR;
    return data;
  }
}

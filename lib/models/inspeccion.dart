class Inspeccion {
  int idInspeccion = 0;
  int idCliente = 0;
  String fecha = '';
  int usuarioAlta = 0;
  String latitud = '';
  String longitud = '';
  int idObra = 0;
  String? supervisor = '';
  String vehiculo = '';
  int nroLegajo = 0;
  String grupoC = '';
  String causanteC = '';
  String dni = '';
  int estado = 0;
  String observacionesInspeccion = '';
  String aviso = '';
  int emailEnviado = 0;
  int requiereReinspeccion = 0;
  int totalPreguntas = 0;
  int respSi = 0;
  int respNo = 0;
  int respNA = 0;
  int totalPuntos = 0;
  String dniSR = '';
  String nombreSR = '';
  int idTipoTrabajo = 0;

  Inspeccion(
      {required this.idInspeccion,
      required this.idCliente,
      required this.fecha,
      required this.usuarioAlta,
      required this.latitud,
      required this.longitud,
      required this.idObra,
      required this.supervisor,
      required this.vehiculo,
      required this.nroLegajo,
      required this.grupoC,
      required this.causanteC,
      required this.dni,
      required this.estado,
      required this.observacionesInspeccion,
      required this.aviso,
      required this.emailEnviado,
      required this.requiereReinspeccion,
      required this.totalPreguntas,
      required this.respSi,
      required this.respNo,
      required this.respNA,
      required this.totalPuntos,
      required this.dniSR,
      required this.nombreSR,
      required this.idTipoTrabajo});

  Inspeccion.fromJson(Map<String, dynamic> json) {
    idInspeccion = json['idInspeccion'];
    idCliente = json['idCliente'];
    fecha = json['fecha'];
    usuarioAlta = json['usuarioAlta'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    idObra = json['idObra'];
    supervisor = json['supervisor'];
    vehiculo = json['vehiculo'];
    nroLegajo = json['nroLegajo'];
    grupoC = json['grupoC'];
    causanteC = json['causanteC'];
    dni = json['dni'];
    estado = json['estado'];
    observacionesInspeccion = json['observacionesInspeccion'];
    aviso = json['aviso'];
    emailEnviado = json['emailEnviado'];
    requiereReinspeccion = json['requiereReinspeccion'];
    totalPreguntas = json['totalPreguntas'];
    respSi = json['respSi'];
    respNo = json['respNo'];
    respNA = json['respNA'];
    totalPuntos = json['totalPuntos'];
    dniSR = json['dniSR'];
    nombreSR = json['nombreSR'];
    idTipoTrabajo = json['idTipoTrabajo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idInspeccion'] = idInspeccion;
    data['idCliente'] = idCliente;
    data['fecha'] = fecha;
    data['usuarioAlta'] = usuarioAlta;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['idObra'] = idObra;
    data['supervisor'] = supervisor;
    data['vehiculo'] = vehiculo;
    data['nroLegajo'] = nroLegajo;
    data['grupoC'] = grupoC;
    data['causanteC'] = causanteC;
    data['dni'] = dni;
    data['estado'] = estado;
    data['observacionesInspeccion'] = observacionesInspeccion;
    data['aviso'] = aviso;
    data['emailEnviado'] = emailEnviado;
    data['requiereReinspeccion'] = requiereReinspeccion;
    data['totalPreguntas'] = totalPreguntas;
    data['respSi'] = respSi;
    data['respNo'] = respNo;
    data['respNA'] = respNA;
    data['totalPuntos'] = totalPuntos;
    data['dniSR'] = dniSR;
    data['nombreSR'] = nombreSR;
    data['idTipoTrabajo'] = idTipoTrabajo;
    return data;
  }
}

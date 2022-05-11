class Inspeccion {
  int idInspeccion = 0;
  int idCliente = 0;
  String fecha = '';
  int usuarioAlta = 0;
  String latitud = '';
  String longitud = '';
  int idObra = 0;
  String supervisor = '';
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
      required this.totalPuntos});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idInspeccion'] = this.idInspeccion;
    data['idCliente'] = this.idCliente;
    data['fecha'] = this.fecha;
    data['usuarioAlta'] = this.usuarioAlta;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['idObra'] = this.idObra;
    data['supervisor'] = this.supervisor;
    data['vehiculo'] = this.vehiculo;
    data['nroLegajo'] = this.nroLegajo;
    data['grupoC'] = this.grupoC;
    data['causanteC'] = this.causanteC;
    data['dni'] = this.dni;
    data['estado'] = this.estado;
    data['observacionesInspeccion'] = this.observacionesInspeccion;
    data['aviso'] = this.aviso;
    data['emailEnviado'] = this.emailEnviado;
    data['requiereReinspeccion'] = this.requiereReinspeccion;
    data['totalPreguntas'] = this.totalPreguntas;
    data['respSi'] = this.respSi;
    data['respNo'] = this.respNo;
    data['respNA'] = this.respNA;
    data['totalPuntos'] = this.totalPuntos;
    return data;
  }
}

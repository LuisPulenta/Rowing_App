class Inspeccion {
  int idinspeccion = 0;
  int idcliente = 0;
  String fecha = '';
  int usuarioalta = 0;
  String latitud = '';
  String longitud = '';
  int idobra = 0;
  String supervisor = '';
  String vehiculo = '';
  int nrolegajo = 0;
  String grupoc = '';
  String causantec = '';
  String dni = '';
  int estado = 0;
  String observacionesinspeccion = '';
  String aviso = '';
  int emailenviado = 0;
  int requiereinspeccion = 0;

  Inspeccion(
      {required this.idinspeccion,
      required this.idcliente,
      required this.fecha,
      required this.usuarioalta,
      required this.latitud,
      required this.longitud,
      required this.idobra,
      required this.supervisor,
      required this.vehiculo,
      required this.nrolegajo,
      required this.grupoc,
      required this.causantec,
      required this.dni,
      required this.estado,
      required this.observacionesinspeccion,
      required this.aviso,
      required this.emailenviado,
      required this.requiereinspeccion});

  Inspeccion.fromJson(Map<String, dynamic> json) {
    idinspeccion = json['idinspeccion'];
    idcliente = json['idcliente'];
    fecha = json['fecha'];
    usuarioalta = json['usuarioalta'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    idobra = json['idobra'];
    supervisor = json['supervisor'];
    vehiculo = json['vehiculo'];
    nrolegajo = json['nrolegajo'];
    grupoc = json['grupoc'];
    causantec = json['causantec'];
    dni = json['dni'];
    estado = json['estado'];
    observacionesinspeccion = json['noobservacionesinspeccionmbre'];
    aviso = json['aviso'];
    emailenviado = json['emailenviado'];
    requiereinspeccion = json['requiereinspeccion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idinspeccion'] = this.idinspeccion;
    data['idcliente'] = this.idcliente;
    data['fecha'] = this.fecha;
    data['usuarioalta'] = this.usuarioalta;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['idobra'] = this.idobra;
    data['supervisor'] = this.supervisor;
    data['vehiculo'] = this.vehiculo;
    data['nrolegajo'] = this.nrolegajo;
    data['grupoc'] = this.grupoc;
    data['causantec'] = this.causantec;
    data['dni'] = this.dni;
    data['estado'] = this.estado;
    data['observacionesinspeccion'] = this.observacionesinspeccion;
    data['aviso'] = this.aviso;
    data['emailenviado'] = this.emailenviado;
    data['requiereinspeccion'] = this.requiereinspeccion;
    return data;
  }
}

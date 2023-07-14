class Turno {
  int idTurno = 0;
  int idUser = 0;
  String? fechaCarga = '';
  String? numcha = '';
  String? codVehiculo = '';
  String? asignadoActual = '';
  String? fechaTurno = '';
  int? horaTurno = 0;
  String? textoBreve = '';
  String? fechaConfirmaTurno = '';
  int? idUserConfirma = 0;
  String? fechaTurnoConfirmado = '';
  int? horaTurnoConfirmado = 0;
  String? grupo = '';
  String? causante = '';
  int? vehiculoRetirado = 0;
  int? idVehiculoParteTaller = 0;
  String? taller = '';

  Turno({
    required this.idTurno,
    required this.idUser,
    required this.fechaCarga,
    required this.numcha,
    required this.codVehiculo,
    required this.asignadoActual,
    required this.fechaTurno,
    required this.horaTurno,
    required this.textoBreve,
    required this.fechaConfirmaTurno,
    required this.idUserConfirma,
    required this.fechaTurnoConfirmado,
    required this.horaTurnoConfirmado,
    required this.grupo,
    required this.causante,
    required this.vehiculoRetirado,
    required this.idVehiculoParteTaller,
    required this.taller,
  });

  Turno.fromJson(Map<String, dynamic> json) {
    idTurno = json['idTurno'];
    idUser = json['idUser'];
    fechaCarga = json['fechaCarga'];
    numcha = json['numcha'];
    codVehiculo = json['codVehiculo'];
    asignadoActual = json['asignadoActual'];
    fechaTurno = json['fechaTurno'];
    horaTurno = json['horaTurno'];
    textoBreve = json['textoBreve'];
    fechaConfirmaTurno = json['fechaConfirmaTurno'];
    idUserConfirma = json['idUserConfirma'];
    fechaTurnoConfirmado = json['fechaTurnoConfirmado'];
    horaTurnoConfirmado = json['horaTurnoConfirmado'];
    grupo = json['grupo'];
    causante = json['causante'];
    vehiculoRetirado = json['vehiculoRetirado'];
    idVehiculoParteTaller = json['idVehiculoParteTaller'];
    taller = json['taller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idTurno'] = idTurno;
    data['idUser'] = idUser;
    data['fechaCarga'] = fechaCarga;
    data['numcha'] = numcha;
    data['codVehiculo'] = codVehiculo;
    data['asignadoActual'] = asignadoActual;
    data['fechaTurno'] = fechaTurno;
    data['horaTurno'] = horaTurno;
    data['textoBreve'] = textoBreve;
    data['fechaConfirmaTurno'] = fechaConfirmaTurno;
    data['idUserConfirma'] = idUserConfirma;
    data['fechaTurnoConfirmado'] = fechaTurnoConfirmado;
    data['horaTurnoConfirmado'] = horaTurnoConfirmado;
    data['grupo'] = grupo;
    data['causante'] = causante;
    data['vehiculoRetirado'] = vehiculoRetirado;
    data['idVehiculoParteTaller'] = idVehiculoParteTaller;
    data['taller'] = taller;
    return data;
  }
}

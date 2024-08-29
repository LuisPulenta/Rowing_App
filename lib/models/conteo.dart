class Conteo {
  int idregistro = 0;
  int idUserCarga = 0;
  int idUserAsignado = 0;
  String fechaCarga = '';
  String grupoD = '';
  String causanteD = '';
  String observacion = '';
  int aprobado = 0;
  String? fechaAprobado = '';
  String terminal = '';
  int idMov901 = 0;
  double monto901 = 0;
  int idMov902 = 0;
  double monto902 = 0;
  int procesadoGaos = 0;
  String nombre = '';

  Conteo(
      {required this.idregistro,
      required this.idUserCarga,
      required this.idUserAsignado,
      required this.fechaCarga,
      required this.grupoD,
      required this.causanteD,
      required this.observacion,
      required this.aprobado,
      required this.fechaAprobado,
      required this.terminal,
      required this.idMov901,
      required this.monto901,
      required this.idMov902,
      required this.monto902,
      required this.procesadoGaos,
      required this.nombre});

  Conteo.fromJson(Map<String, dynamic> json) {
    idregistro = json['idregistro'];
    idUserCarga = json['idUserCarga'];
    idUserAsignado = json['idUserAsignado'];
    fechaCarga = json['fechaCarga'];
    grupoD = json['grupoD'];
    causanteD = json['causanteD'];
    observacion = json['observacion'];
    aprobado = json['aprobado'];
    fechaAprobado = json['fechaAprobado'];
    terminal = json['terminal'];
    idMov901 = json['idMov901'];
    monto901 = json['monto901'];
    idMov902 = json['idMov902'];
    monto902 = json['monto902'];
    procesadoGaos = json['procesadoGaos'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idregistro'] = idregistro;
    data['idUserCarga'] = idUserCarga;
    data['idUserAsignado'] = idUserAsignado;
    data['fechaCarga'] = fechaCarga;
    data['grupoD'] = grupoD;
    data['causanteD'] = causanteD;
    data['observacion'] = observacion;
    data['aprobado'] = aprobado;
    data['fechaAprobado'] = fechaAprobado;
    data['terminal'] = terminal;
    data['idMov901'] = idMov901;
    data['monto901'] = monto901;
    data['idMov902'] = idMov902;
    data['monto902'] = monto902;
    data['procesadoGaos'] = procesadoGaos;
    data['nombre'] = nombre;
    return data;
  }
}

class Novedad {
  int idnovedad = 0;
  String grupo = '';
  String causante = '';
  String fechacarga = '';
  String fechanovedad = '';
  String empresa = '';
  String fechainicio = '';
  String fechafin = '';
  String tiponovedad = '';
  String? observaciones = '';
  int vistaRRHH = 0;
  int idusuario = 0;

  String? fechaEstado = '';
  String? observacionEstado = '';
  int? confirmaLeido = 0;
  int? iIDUsrEstado = 0;
  String? estado = '';

  Novedad(
      {required this.idnovedad,
      required this.grupo,
      required this.causante,
      required this.fechacarga,
      required this.fechanovedad,
      required this.empresa,
      required this.fechainicio,
      required this.fechafin,
      required this.tiponovedad,
      required this.observaciones,
      required this.vistaRRHH,
      required this.idusuario,
      required this.fechaEstado,
      required this.observacionEstado,
      required this.confirmaLeido,
      required this.iIDUsrEstado,
      required this.estado});

  Novedad.fromJson(Map<String, dynamic> json) {
    idnovedad = json['idnovedad'];
    grupo = json['grupo'];
    causante = json['causante'];
    fechacarga = json['fechacarga'];
    fechanovedad = json['fechanovedad'];
    empresa = json['empresa'];
    fechainicio = json['fechainicio'];
    fechafin = json['fechafin'];
    tiponovedad = json['tiponovedad'];
    observaciones = json['observaciones'];
    vistaRRHH = json['vistaRRHH'];
    idusuario = json['idusuario'];

    fechaEstado = json['fechaEstado'];
    observacionEstado = json['observacionEstado'];
    confirmaLeido = json['confirmaLeido'];
    iIDUsrEstado = json['iIDUsrEstado'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idnovedad'] = idnovedad;
    data['grupo'] = grupo;
    data['causante'] = causante;
    data['fechacarga'] = fechacarga;
    data['fechanovedad'] = fechanovedad;
    data['empresa'] = empresa;
    data['fechainicio'] = fechainicio;
    data['fechafin'] = fechafin;
    data['tiponovedad'] = tiponovedad;
    data['observaciones'] = observaciones;
    data['vistaRRHH'] = vistaRRHH;
    data['idusuario'] = idusuario;

    data['fechaEstado'] = fechaEstado;
    data['observacionEstado'] = observacionEstado;
    data['confirmaLeido'] = confirmaLeido;
    data['iIDUsrEstado'] = iIDUsrEstado;
    data['estado'] = estado;
    return data;
  }
}

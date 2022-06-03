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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idnovedad'] = this.idnovedad;
    data['grupo'] = this.grupo;
    data['causante'] = this.causante;
    data['fechacarga'] = this.fechacarga;
    data['fechanovedad'] = this.fechanovedad;
    data['empresa'] = this.empresa;
    data['fechainicio'] = this.fechainicio;
    data['fechafin'] = this.fechafin;
    data['tiponovedad'] = this.tiponovedad;
    data['observaciones'] = this.observaciones;
    data['vistaRRHH'] = this.vistaRRHH;
    data['idusuario'] = this.idusuario;

    data['fechaEstado'] = this.fechaEstado;
    data['observacionEstado'] = this.observacionEstado;
    data['confirmaLeido'] = this.confirmaLeido;
    data['iIDUsrEstado'] = this.iIDUsrEstado;
    data['estado'] = this.estado;
    return data;
  }
}

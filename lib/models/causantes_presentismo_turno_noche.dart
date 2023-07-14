class CausantesPresentismoTurnoNoche {
  int idpresentismo = 0;
  int idsupervisor = 0;
  String fecha = '';
  int hora = 0;
  String grupoc = '';
  String causantec = '';
  String estado = '';
  String? zonatrabajo = '';
  String? actividad = '';
  String? ceco = '';
  String? observaciones = '';
  String? perteneceCuadrilla = '';
  String? nombre = '';

  CausantesPresentismoTurnoNoche(
      {required this.idpresentismo,
      required this.idsupervisor,
      required this.fecha,
      required this.hora,
      required this.grupoc,
      required this.causantec,
      required this.estado,
      required this.zonatrabajo,
      required this.actividad,
      required this.ceco,
      required this.observaciones,
      required this.perteneceCuadrilla,
      required this.nombre});

  CausantesPresentismoTurnoNoche.fromJson(Map<String, dynamic> json) {
    idpresentismo = json['idpresentismo'];
    idsupervisor = json['idsupervisor'];
    fecha = json['fecha'];
    hora = json['hora'];
    grupoc = json['grupoc'];
    causantec = json['causantec'];
    estado = json['estado'];
    zonatrabajo = json['zonatrabajo'];
    actividad = json['actividad'];
    ceco = json['ceco'];
    observaciones = json['observaciones'];
    perteneceCuadrilla = json['perteneceCuadrilla'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idpresentismo'] = idpresentismo;
    data['idsupervisor'] = idsupervisor;
    data['fecha'] = fecha;
    data['hora'] = hora;
    data['grupoc'] = grupoc;
    data['causantec'] = causantec;
    data['estado'] = estado;
    data['zonatrabajo'] = zonatrabajo;
    data['actividad'] = actividad;
    data['ceco'] = ceco;
    data['observaciones'] = observaciones;
    data['perteneceCuadrilla'] = perteneceCuadrilla;
    data['nombre'] = nombre;

    return data;
  }
}

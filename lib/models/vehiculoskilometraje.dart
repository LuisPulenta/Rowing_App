class VehiculosKilometraje {
  int orden = 0;
  String? fecha = '';
  String? equipo = '';
  int? kilini = 0;
  int? kilfin = 0;
  int? horsal = 0;
  int? horlle = 0;
  int? codsuc = 0;
  int? nrodeot = 0;
  String? cambio = '';
  int? procesado = 0;
  String? kmfechaanterior = '';
  int? nopromediar = 0;
  String? fechaalta = '';

  VehiculosKilometraje(
      {required this.orden,
      required this.fecha,
      required this.equipo,
      required this.kilini,
      required this.kilfin,
      required this.horsal,
      required this.horlle,
      required this.codsuc,
      required this.nrodeot,
      required this.cambio,
      required this.procesado,
      required this.kmfechaanterior,
      required this.nopromediar,
      required this.fechaalta});

  VehiculosKilometraje.fromJson(Map<String, dynamic> json) {
    orden = json['orden'];
    fecha = json['fecha'];
    equipo = json['equipo'];
    kilini = json['kilini'];
    kilfin = json['kilfin'];
    horsal = json['horsal'];
    horlle = json['horlle'];
    codsuc = json['codsuc'];
    nrodeot = json['nrodeot'];
    cambio = json['cambio'];
    procesado = json['procesado'];
    kmfechaanterior = json['kmfechaanterior'];
    nopromediar = json['nopromediar'];
    fechaalta = json['fechaalta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orden'] = orden;
    data['fecha'] = fecha;
    data['equipo'] = equipo;
    data['kilini'] = kilini;
    data['kilfin'] = kilfin;
    data['horsal'] = horsal;
    data['horlle'] = horlle;
    data['codsuc'] = codsuc;
    data['nrodeot'] = nrodeot;
    data['cambio'] = cambio;
    data['procesado'] = procesado;
    data['kmfechaanterior'] = kmfechaanterior;
    data['nopromediar'] = nopromediar;
    data['fechaalta'] = fechaalta;
    return data;
  }
}

class Preventivo {
  int nroInterno = 0;
  String numcha = '';
  String? descripcionParte = '';
  String? frecuencia = '';
  int? cantFrec = 0;
  String? descripcion = '';
  String? ultFechaEJ = '';
  int? ultKmHsEj = 0;
  int? actKmHsEj = 0;
  int? diferencia = 0;
  String? estados = '';

  Preventivo(
      {required this.nroInterno,
      required this.numcha,
      required this.descripcionParte,
      required this.frecuencia,
      required this.cantFrec,
      required this.descripcion,
      required this.ultFechaEJ,
      required this.ultKmHsEj,
      required this.actKmHsEj,
      required this.diferencia,
      required this.estados});

  Preventivo.fromJson(Map<String, dynamic> json) {
    nroInterno = json['nroInterno'];
    numcha = json['numcha'];
    descripcionParte = json['descripcionParte'];
    frecuencia = json['frecuencia'];
    cantFrec = json['cantFrec'];
    descripcion = json['descripcion'];
    ultFechaEJ = json['ultFechaEJ'];
    ultKmHsEj = json['ultKmHsEj'];
    actKmHsEj = json['actKmHsEj'];
    diferencia = json['diferencia'];
    estados = json['estados'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroInterno'] = nroInterno;
    data['numcha'] = numcha;
    data['descripcionParte'] = descripcionParte;
    data['frecuencia'] = frecuencia;
    data['cantFrec'] = cantFrec;
    data['descripcion'] = descripcion;
    data['ultFechaEJ'] = ultFechaEJ;
    data['ultKmHsEj'] = ultKmHsEj;
    data['actKmHsEj'] = actKmHsEj;
    data['diferencia'] = diferencia;
    data['estados'] = estados;
    return data;
  }
}

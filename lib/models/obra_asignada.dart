class ObraAsignada {
  int nroregistro = 0;
  int nroobra = 0;
  String? subcontratista = '';
  String? causante = '';
  String? tareaquerealiza = '';
  String? observacion = '';
  String? fechaalta = '';
  String? fechafinasignacion = '';
  int idusr = 0;
  String? fechaCierre = '';
  String? nombreObra = '';
  String? modulo = '';
  String? elempep = '';

  ObraAsignada({
    required this.nroregistro,
    required this.nroobra,
    required this.subcontratista,
    required this.causante,
    required this.tareaquerealiza,
    required this.observacion,
    required this.fechaalta,
    required this.fechafinasignacion,
    required this.idusr,
    required this.fechaCierre,
    required this.nombreObra,
    required this.modulo,
    required this.elempep,
  });

  ObraAsignada.fromJson(Map<String, dynamic> json) {
    nroregistro = json['nroregistro'];
    nroobra = json['nroobra'] ?? '';
    subcontratista = json['subcontratista'];
    causante = json['causante'];
    tareaquerealiza = json['tareaquerealiza'];
    observacion = json['observacion'];
    fechaalta = json['fechaalta'];
    fechafinasignacion = json['fechafinasignacion'];
    idusr = json['idusr'];
    fechaCierre = json['fechaCierre'];
    nombreObra = json['nombreObra'];
    modulo = json['modulo'];
    elempep = json['elempep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroregistro'] = nroregistro;
    data['nroobra'] = nroobra;
    data['subcontratista'] = subcontratista;
    data['causante'] = causante;
    data['tareaquerealiza'] = tareaquerealiza;
    data['observacion'] = observacion;
    data['fechaalta'] = fechaalta;
    data['fechafinasignacion'] = fechafinasignacion;
    data['idusr'] = idusr;
    data['fechaCierre'] = fechaCierre;
    data['nombreObra'] = nombreObra;
    data['modulo'] = modulo;
    data['elempep'] = elempep;
    return data;
  }
}

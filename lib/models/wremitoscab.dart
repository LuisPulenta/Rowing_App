class WRemitosCab {
  int nroremito = 0;
  int nroobra = 0;
  int? nroReserva = 0;
  String? nroGrafo = '';
  String? fechacarga = '';
  String? contratista = '';
  int? idusuario = 0;
  int? confirmagenerado = 0;
  int? confirmaentregado = 0;
  int? anulado = 0;
  String? tipo = '';
  String? retira = '';
  String? clasificacion = '';
  String? observacion = '';
  String? codgrupoc = '';
  String? codcausantec = '';
  String? codgruporec = '';
  String? codcausanterec = '';
  String? codconcepto = '';
  String? fecharetiro = '';
  String? prioridad = '';
  int? faltamaterial = 0;
  int? despachado;
  String? terminal = '';
  int? pordiferencia;
  String? entregadocontratista = '';
  String? modulo = '';
  int? cobradO602 = 0;
  int? nroop = 0;
  double? valorizacion = 0;

  WRemitosCab(
      {required this.nroremito,
      required this.nroobra,
      required this.nroReserva,
      required this.nroGrafo,
      required this.fechacarga,
      required this.contratista,
      required this.idusuario,
      required this.confirmagenerado,
      required this.confirmaentregado,
      required this.anulado,
      required this.tipo,
      required this.retira,
      required this.clasificacion,
      required this.observacion,
      required this.codgrupoc,
      required this.codcausantec,
      required this.codgruporec,
      required this.codcausanterec,
      required this.codconcepto,
      required this.fecharetiro,
      required this.prioridad,
      required this.faltamaterial,
      required this.despachado,
      required this.terminal,
      required this.pordiferencia,
      required this.entregadocontratista,
      required this.modulo,
      required this.cobradO602,
      required this.nroop,
      required this.valorizacion});

  WRemitosCab.fromJson(Map<String, dynamic> json) {
    nroremito = json['nroremito'];
    nroobra = json['nroobra'];
    nroReserva = json['nroReserva'];
    nroGrafo = json['nroGrafo'];
    fechacarga = json['fechacarga'];
    contratista = json['contratista'];
    idusuario = json['idusuario'];
    confirmagenerado = json['confirmagenerado'];
    confirmaentregado = json['confirmaentregado'];
    anulado = json['anulado'];
    tipo = json['tipo'];
    retira = json['retira'];
    clasificacion = json['clasificacion'];
    observacion = json['observacion'];
    codgrupoc = json['codgrupoc'];
    codcausantec = json['codcausantec'];
    codgruporec = json['codgruporec'];
    codcausanterec = json['codcausanterec'];
    codconcepto = json['codconcepto'];
    fecharetiro = json['fecharetiro'];
    prioridad = json['prioridad'];
    faltamaterial = json['faltamaterial'];
    despachado = json['despachado'];
    terminal = json['terminal'];
    pordiferencia = json['pordiferencia'];
    entregadocontratista = json['entregadocontratista'];
    modulo = json['modulo'];
    cobradO602 = json['cobradO602'];
    nroop = json['nroop'];
    valorizacion = json['valorizacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroremito'] = nroremito;
    data['nroobra'] = nroobra;
    data['nroReserva'] = nroReserva;
    data['nroGrafo'] = nroGrafo;
    data['fechacarga'] = fechacarga;
    data['contratista'] = contratista;
    data['idusuario'] = idusuario;
    data['confirmagenerado'] = confirmagenerado;
    data['confirmaentregado'] = confirmaentregado;
    data['anulado'] = anulado;
    data['tipo'] = tipo;
    data['retira'] = retira;
    data['clasificacion'] = clasificacion;
    data['observacion'] = observacion;
    data['codgrupoc'] = codgrupoc;
    data['codcausantec'] = codcausantec;
    data['codgruporec'] = codgruporec;
    data['codcausanterec'] = codcausanterec;
    data['codconcepto'] = codconcepto;
    data['fecharetiro'] = fecharetiro;
    data['prioridad'] = prioridad;
    data['faltamaterial'] = faltamaterial;
    data['despachado'] = despachado;
    data['terminal'] = terminal;
    data['pordiferencia'] = pordiferencia;
    data['entregadocontratista'] = entregadocontratista;
    data['modulo'] = modulo;
    data['cobradO602'] = cobradO602;
    data['nroop'] = nroop;
    data['valorizacion'] = valorizacion;
    return data;
  }
}

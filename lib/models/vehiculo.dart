class Vehiculo {
  int codveh = 0;
  String? numcha = '';
  String? nrotar = '';
  String? codProducto = '';
  int? aniofa = 0;
  String? descripcion = '';
  String? nmotor = '';
  String? chasis = '';
  int? fechaVencITV = 0;
  String? nroPolizaSeguro = '';
  String? centroCosto = '';
  String? propiedadDe = '';
  String? telepase = '';
  int? kmhsactual = 0;
  int? usaHoras = 0;
  int? habilitado = 0;
  int? fechaVencObleaGAS = 0;
  String? modulo = '';
  String? campomemo = '';
  int? habilitaChecklist = 0;

  Vehiculo(
      {required this.codveh,
      required this.numcha,
      required this.nrotar,
      required this.codProducto,
      required this.aniofa,
      required this.descripcion,
      required this.nmotor,
      required this.chasis,
      required this.fechaVencITV,
      required this.nroPolizaSeguro,
      required this.centroCosto,
      required this.propiedadDe,
      required this.telepase,
      required this.kmhsactual,
      required this.usaHoras,
      required this.habilitado,
      required this.fechaVencObleaGAS,
      required this.modulo,
      required this.campomemo,
      required this.habilitaChecklist});

  Vehiculo.fromJson(Map<String, dynamic> json) {
    codveh = json['codveh'];
    numcha = json['numcha'];
    nrotar = json['nrotar'];
    codProducto = json['codProducto'];
    aniofa = json['aniofa'];
    descripcion = json['descripcion'];
    nmotor = json['nmotor'];
    chasis = json['chasis'];
    fechaVencITV = json['fechaVencITV'];
    nroPolizaSeguro = json['nroPolizaSeguro'];
    centroCosto = json['centroCosto'];
    propiedadDe = json['propiedadDe'];
    telepase = json['telepase'];
    kmhsactual = json['kmhsactual'];
    usaHoras = json['usaHoras'];
    habilitado = json['habilitado'];
    fechaVencObleaGAS = json['fechaVencObleaGAS'];
    modulo = json['modulo'];
    campomemo = json['campomemo'];
    habilitaChecklist = json['habilitaChecklist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codveh'] = codveh;
    data['numcha'] = numcha;
    data['nrotar'] = nrotar;
    data['codProducto'] = codProducto;
    data['aniofa'] = aniofa;
    data['descripcion'] = descripcion;
    data['nmotor'] = nmotor;
    data['chasis'] = chasis;
    data['fechaVencITV'] = fechaVencITV;
    data['nroPolizaSeguro'] = nroPolizaSeguro;
    data['centroCosto'] = centroCosto;
    data['propiedadDe'] = propiedadDe;
    data['telepase'] = telepase;
    data['kmhsactual'] = kmhsactual;
    data['usaHoras'] = usaHoras;
    data['habilitado'] = habilitado;
    data['fechaVencObleaGAS'] = fechaVencObleaGAS;
    data['modulo'] = modulo;
    data['campomemo'] = campomemo;
    data['habilitaChecklist'] = habilitaChecklist;
    return data;
  }
}

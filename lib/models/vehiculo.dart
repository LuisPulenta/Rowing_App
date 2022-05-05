class Vehiculo {
  int codveh = 0;
  String? numcha = '';
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

  Vehiculo(
      {required this.codveh,
      required this.numcha,
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
      required this.campomemo});

  Vehiculo.fromJson(Map<String, dynamic> json) {
    codveh = json['codveh'];
    numcha = json['numcha'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codveh'] = this.codveh;
    data['numcha'] = this.numcha;
    data['codProducto'] = this.codProducto;
    data['aniofa'] = this.aniofa;
    data['descripcion'] = this.descripcion;
    data['nmotor'] = this.nmotor;
    data['chasis'] = this.chasis;
    data['fechaVencITV'] = this.fechaVencITV;
    data['nroPolizaSeguro'] = this.nroPolizaSeguro;
    data['centroCosto'] = this.centroCosto;
    data['propiedadDe'] = this.propiedadDe;
    data['telepase'] = this.telepase;
    data['kmhsactual'] = this.kmhsactual;
    data['usaHoras'] = this.usaHoras;
    data['habilitado'] = this.habilitado;
    data['fechaVencObleaGAS'] = this.fechaVencObleaGAS;
    data['modulo'] = this.modulo;
    data['campomemo'] = this.campomemo;
    return data;
  }
}

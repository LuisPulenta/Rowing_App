class Juicio {
  int iDCASO = 0;
  String? tipocaso = '';
  String? estado = '';
  String? fechAINICIO = '';
  String? fEULTMOV = '';
  int? cerrado = 0;
  String? fechACIERRE = '';
  String? caratula = '';
  String? cliente = '';
  String? abogado = '';
  String? juzgado = '';
  String? escribano = '';
  String? juez = '';
  double? importejuicio = 0;
  String? moneda = '';
  double? importerealdeuda = 0;
  String? fechAVENCIMIENTO = '';
  String? fechacalculo = '';
  int? diasatraso = 0;
  double? intereseSMORATORIOS = 0;
  double? importeinteres = 0;
  double? intereseSPUNITORIOS = 0;
  double? importepunitorio = 0;
  double? gastoSJUDICIALES = 0;
  double? importegastos = 0;
  int? cobroscliente = 0;
  double? pagosdemandado = 0;
  double? honorarios = 0;
  double? importehonorarios = 0;
  int? varios = 0;
  double? importevarios = 0;
  int? periodo = 0;
  String? grupo = '';
  String? causante = '';
  int? iduserimput = 0;
  String? nroExpediente = '';
  int? idContraparte = 0;

  Juicio(
      {required this.iDCASO,
      required this.tipocaso,
      required this.estado,
      required this.fechAINICIO,
      required this.fEULTMOV,
      required this.cerrado,
      required this.fechACIERRE,
      required this.caratula,
      required this.cliente,
      required this.abogado,
      required this.juzgado,
      required this.escribano,
      required this.juez,
      required this.importejuicio,
      required this.moneda,
      required this.importerealdeuda,
      required this.fechAVENCIMIENTO,
      required this.fechacalculo,
      required this.diasatraso,
      required this.intereseSMORATORIOS,
      required this.importeinteres,
      required this.intereseSPUNITORIOS,
      required this.importepunitorio,
      required this.gastoSJUDICIALES,
      required this.importegastos,
      required this.cobroscliente,
      required this.pagosdemandado,
      required this.honorarios,
      required this.importehonorarios,
      required this.varios,
      required this.importevarios,
      required this.periodo,
      required this.grupo,
      required this.causante,
      required this.iduserimput,
      required this.nroExpediente,
      required this.idContraparte});

  Juicio.fromJson(Map<String, dynamic> json) {
    iDCASO = json['iD_CASO'];
    tipocaso = json['tipocaso'];
    estado = json['estado'];
    fechAINICIO = json['fechA_INICIO'];
    fEULTMOV = json['fE_ULT_MOV'];
    cerrado = json['cerrado'];
    fechACIERRE = json['fechA_CIERRE'];
    caratula = json['caratula'];
    cliente = json['cliente'];
    abogado = json['abogado'];
    juzgado = json['juzgado'];
    escribano = json['escribano'];
    juez = json['juez'];
    importejuicio = json['importejuicio'];
    moneda = json['moneda'];
    importerealdeuda = json['importerealdeuda'];
    fechAVENCIMIENTO = json['fechA_VENCIMIENTO'];
    fechacalculo = json['fechacalculo'];
    diasatraso = json['diasatraso'];
    intereseSMORATORIOS = json['intereseS_MORATORIOS'];
    importeinteres = json['importeinteres'];
    intereseSPUNITORIOS = json['intereseS_PUNITORIOS'];
    importepunitorio = json['importepunitorio'];
    gastoSJUDICIALES = json['gastoS_JUDICIALES'];
    importegastos = json['importegastos'];
    cobroscliente = json['cobroscliente'];
    pagosdemandado = json['pagosdemandado'];
    honorarios = json['honorarios'];
    importehonorarios = json['importehonorarios'];
    varios = json['varios'];
    importevarios = json['importevarios'];
    periodo = json['periodo'];
    grupo = json['grupo'];
    causante = json['causante'];
    iduserimput = json['iduserimput'];
    nroExpediente = json['nroExpediente'];
    idContraparte = json['idContraparte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iD_CASO'] = iDCASO;
    data['tipocaso'] = tipocaso;
    data['estado'] = estado;
    data['fechA_INICIO'] = fechAINICIO;
    data['fE_ULT_MOV'] = fEULTMOV;
    data['cerrado'] = cerrado;
    data['fechA_CIERRE'] = fechACIERRE;
    data['caratula'] = caratula;
    data['cliente'] = cliente;
    data['abogado'] = abogado;
    data['juzgado'] = juzgado;
    data['escribano'] = escribano;
    data['juez'] = juez;
    data['importejuicio'] = importejuicio;
    data['moneda'] = moneda;
    data['importerealdeuda'] = importerealdeuda;
    data['fechA_VENCIMIENTO'] = fechAVENCIMIENTO;
    data['fechacalculo'] = fechacalculo;
    data['diasatraso'] = diasatraso;
    data['intereseS_MORATORIOS'] = intereseSMORATORIOS;
    data['importeinteres'] = importeinteres;
    data['intereseS_PUNITORIOS'] = intereseSPUNITORIOS;
    data['importepunitorio'] = importepunitorio;
    data['gastoS_JUDICIALES'] = gastoSJUDICIALES;
    data['importegastos'] = importegastos;
    data['cobroscliente'] = cobroscliente;
    data['pagosdemandado'] = pagosdemandado;
    data['honorarios'] = honorarios;
    data['importehonorarios'] = importehonorarios;
    data['varios'] = varios;
    data['importevarios'] = importevarios;
    data['periodo'] = periodo;
    data['grupo'] = grupo;
    data['causante'] = causante;
    data['iduserimput'] = iduserimput;
    data['nroExpediente'] = nroExpediente;
    data['idContraparte'] = idContraparte;
    return data;
  }
}

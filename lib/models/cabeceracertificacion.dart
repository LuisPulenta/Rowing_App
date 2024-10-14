class CabeceraCertificacion {
  int id = 0;
  int nroobra = 0;
  String? defProy = '';
  String? fechacarga = '';
  String? fechadespacho = '';
  String? fechaejecucion = '';
  String? nombreObra = '';
  String? nroOE = '';
  int? finalizada = 0;
  int? materialesdescontados = 0;
  String? subCodigo = '';
  String? central = '';
  int? preadicional = 0;
  int? nroPre = 0;
  String? sipa = '';
  String? observacion = '';
  String? tipificacion = '';
  int? fechacorrespondencia = 0;
  int? marcadeventa = 0;
  String? nrO103 = '';
  String? nrO105 = '';
  int? idusuariop = 0;
  String? fechaliberacion = '';
  int? idusuariol = 0;
  int? nroordenpago = 0;
  double? valortotal = 0;
  String? pagaR90 = '';
  double? valoR90 = 0;
  double? preciO90 = 0;
  double? montO90 = 0;
  String? pagaR10 = '';
  double? valoR10 = 0;
  double? preciO10 = 0;
  double? montO10 = 0;
  int? idusuariofr = 0;
  String? fechafondoreparo = '';
  int? nropagofr = 0;
  String? codigoproduccion = '';
  String? observacionO = '';
  String? clase = '';
  double? valortotalc = 0;
  double? valortotalt = 0;
  double? porcAplicado = 0;
  String? pagarx = '';
  double? valorx = 0;
  double? preciO10X = 0;
  double? montox = 0;
  String? codCausanteC = '';
  int? cobrar = 0;
  String? presentado = '';
  String? estado = '';
  String? modulo = '';
  int? idUsuario = 0;
  String? terminal = '';
  String? fecha103 = '';
  String? fecha105 = '';
  int? mesImputacion = 0;
  String? objeto = '';
  double? porcActa = 0;

  CabeceraCertificacion(
      {required this.id,
      required this.nroobra,
      required this.defProy,
      required this.fechacarga,
      required this.fechadespacho,
      required this.fechaejecucion,
      required this.nombreObra,
      required this.nroOE,
      required this.finalizada,
      required this.materialesdescontados,
      required this.subCodigo,
      required this.central,
      required this.preadicional,
      required this.nroPre,
      required this.sipa,
      required this.observacion,
      required this.tipificacion,
      required this.fechacorrespondencia,
      required this.marcadeventa,
      required this.nrO103,
      required this.nrO105,
      required this.idusuariop,
      required this.fechaliberacion,
      required this.idusuariol,
      required this.nroordenpago,
      required this.valortotal,
      required this.pagaR90,
      required this.valoR90,
      required this.preciO90,
      required this.montO90,
      required this.pagaR10,
      required this.valoR10,
      required this.preciO10,
      required this.montO10,
      required this.idusuariofr,
      required this.fechafondoreparo,
      required this.nropagofr,
      required this.codigoproduccion,
      required this.observacionO,
      required this.clase,
      required this.valortotalc,
      required this.valortotalt,
      required this.porcAplicado,
      required this.pagarx,
      required this.valorx,
      required this.preciO10X,
      required this.montox,
      required this.codCausanteC,
      required this.cobrar,
      required this.presentado,
      required this.estado,
      required this.modulo,
      required this.idUsuario,
      required this.terminal,
      required this.fecha103,
      required this.fecha105,
      required this.mesImputacion,
      required this.objeto,
      required this.porcActa});

  CabeceraCertificacion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nroobra = json['nroobra'];
    defProy = json['defProy'];
    fechacarga = json['fechacarga'];
    fechadespacho = json['fechadespacho'];
    fechaejecucion = json['fechaejecucion'];
    nombreObra = json['nombreObra'];
    nroOE = json['nroOE'];
    finalizada = json['finalizada'];
    materialesdescontados = json['materialesdescontados'];
    subCodigo = json['subCodigo'];
    central = json['central'];
    preadicional = json['preadicional'];
    nroPre = json['nroPre'];
    sipa = json['sipa'];
    observacion = json['observacion'];
    tipificacion = json['tipificacion'];
    fechacorrespondencia = json['fechacorrespondencia'];
    marcadeventa = json['marcadeventa'];
    nrO103 = json['nrO103'];
    nrO105 = json['nrO105'];
    idusuariop = json['idusuariop'];
    fechaliberacion = json['fechaliberacion'];
    idusuariol = json['idusuariol'];
    nroordenpago = json['nroordenpago'];
    valortotal = json['valortotal'];
    pagaR90 = json['pagaR90'];
    valoR90 = json['valoR90'];
    preciO90 = json['preciO90'];
    montO90 = json['montO90'];
    pagaR10 = json['pagaR10'];
    valoR10 = json['valoR10'];
    preciO10 = json['preciO10'];
    montO10 = json['montO10'];
    idusuariofr = json['idusuariofr'];
    fechafondoreparo = json['fechafondoreparo'];
    nropagofr = json['nropagofr'];
    codigoproduccion = json['codigoproduccion'];
    observacionO = json['observacionO'];
    clase = json['clase'];
    valortotalc = json['valortotalc'];
    valortotalt = json['valortotalt'];
    porcAplicado = json['porcAplicado'];
    pagarx = json['pagarx'];
    valorx = json['valorx'];
    preciO10X = json['preciO10X'];
    montox = json['montox'];
    codCausanteC = json['codCausanteC'];
    cobrar = json['cobrar'];
    presentado = json['presentado'];
    estado = json['estado'];
    modulo = json['modulo'];
    idUsuario = json['idUsuario'];
    terminal = json['terminal'];
    fecha103 = json['fecha103'];
    fecha105 = json['fecha105'];
    mesImputacion = json['mesImputacion'];
    objeto = json['objeto'];
    porcActa = json['porcActa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nroobra'] = nroobra;
    data['defProy'] = defProy;
    data['fechacarga'] = fechacarga;
    data['fechadespacho'] = fechadespacho;
    data['fechaejecucion'] = fechaejecucion;
    data['nombreObra'] = nombreObra;
    data['nroOE'] = nroOE;
    data['finalizada'] = finalizada;
    data['materialesdescontados'] = materialesdescontados;
    data['subCodigo'] = subCodigo;
    data['central'] = central;
    data['preadicional'] = preadicional;
    data['nroPre'] = nroPre;
    data['sipa'] = sipa;
    data['observacion'] = observacion;
    data['tipificacion'] = tipificacion;
    data['fechacorrespondencia'] = fechacorrespondencia;
    data['marcadeventa'] = marcadeventa;
    data['nrO103'] = nrO103;
    data['nrO105'] = nrO105;
    data['idusuariop'] = idusuariop;
    data['fechaliberacion'] = fechaliberacion;
    data['idusuariol'] = idusuariol;
    data['nroordenpago'] = nroordenpago;
    data['valortotal'] = valortotal;
    data['pagaR90'] = pagaR90;
    data['valoR90'] = valoR90;
    data['preciO90'] = preciO90;
    data['montO90'] = montO90;
    data['pagaR10'] = pagaR10;
    data['valoR10'] = valoR10;
    data['preciO10'] = preciO10;
    data['montO10'] = montO10;
    data['idusuariofr'] = idusuariofr;
    data['fechafondoreparo'] = fechafondoreparo;
    data['nropagofr'] = nropagofr;
    data['codigoproduccion'] = codigoproduccion;
    data['observacionO'] = observacionO;
    data['clase'] = clase;
    data['valortotalc'] = valortotalc;
    data['valortotalt'] = valortotalt;
    data['porcAplicado'] = porcAplicado;
    data['pagarx'] = pagarx;
    data['valorx'] = valorx;
    data['preciO10X'] = preciO10X;
    data['montox'] = montox;
    data['codCausanteC'] = codCausanteC;
    data['cobrar'] = cobrar;
    data['presentado'] = presentado;
    data['estado'] = estado;
    data['modulo'] = modulo;
    data['idUsuario'] = idUsuario;
    data['terminal'] = terminal;
    data['fecha103'] = fecha103;
    data['fecha105'] = fecha105;
    data['mesImputacion'] = mesImputacion;
    data['objeto'] = objeto;
    data['porcActa'] = porcActa;
    return data;
  }
}

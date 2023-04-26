class VehiculosCheckList {
  int idCheckList = 0;
  String? fecha = '';
  int? idUser = 0;
  int? idCliente = 0;
  String? cliente = '';
  int? idVehiculo = 0;
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
  String? vtv = '';
  String? fechaVencVTV = '';
  String? vth = '';
  String? fechaVencVTH = '';
  String? cubiertas = '';
  String? correaCinturon = '';
  String? apoyaCabezas = '';
  String? limpiavidrios = '';
  String? espejos = '';
  String? indicadoresDeGiro = '';
  String? bocina = '';
  String? dispositivoPAT = '';
  String? ganchos = '';
  String? alarmaRetroceso = '';
  String? manguerasCircuitoHidraulico = '';
  String? farosDelanteros = '';
  String? farosTraseros = '';
  String? luzPosicion = '';
  String? luzFreno = '';
  String? luzRetroceso = '';
  String? luzEmergencia = '';
  String? balizaPortatil = '';
  String? matafuegos = '';
  String? identificadorEmpresa = '';
  String? sobreSalientesPeligro = '';
  String? diagramaDeCarga = '';
  String? fajas = '';
  String? grilletes = '';
  String? cintaSujecionCarga = '';
  String? jefeDirecto = '';
  String? responsableVehiculo = '';
  String? observaciones = '';
  String? grupoC = '';
  String? causanteC = '';
  String? nombre = '';
  String? dni = '';
  String? apellidoNombre = '';
  String? seguro = '';
  String? fechaVencSeguro = '';

  VehiculosCheckList({
    required this.idCheckList,
    required this.fecha,
    required this.idUser,
    required this.idCliente,
    required this.cliente,
    required this.idVehiculo,
    required this.numcha,
    required this.nrotar,
    required this.codProducto,
    required this.aniofa,
    required this.descripcion,
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
    required this.vtv,
    required this.fechaVencVTV,
    required this.vth,
    required this.fechaVencVTH,
    required this.cubiertas,
    required this.correaCinturon,
    required this.apoyaCabezas,
    required this.limpiavidrios,
    required this.espejos,
    required this.indicadoresDeGiro,
    required this.bocina,
    required this.dispositivoPAT,
    required this.ganchos,
    required this.alarmaRetroceso,
    required this.manguerasCircuitoHidraulico,
    required this.farosDelanteros,
    required this.farosTraseros,
    required this.luzPosicion,
    required this.luzFreno,
    required this.luzRetroceso,
    required this.luzEmergencia,
    required this.balizaPortatil,
    required this.matafuegos,
    required this.identificadorEmpresa,
    required this.sobreSalientesPeligro,
    required this.diagramaDeCarga,
    required this.fajas,
    required this.grilletes,
    required this.cintaSujecionCarga,
    required this.jefeDirecto,
    required this.responsableVehiculo,
    required this.observaciones,
    required this.grupoC,
    required this.causanteC,
    required this.nombre,
    required this.dni,
    required this.apellidoNombre,
    required this.seguro,
    required this.fechaVencSeguro,
  });

  VehiculosCheckList.fromJson(Map<String, dynamic> json) {
    idCheckList = json['idCheckList'];
    fecha = json['fecha'];
    idUser = json['idUser'];
    idCliente = json['idCliente'];
    cliente = json['cliente'];
    idVehiculo = json['idVehiculo'];
    numcha = json['numcha'];
    nrotar = json['nrotar'];
    codProducto = json['codProducto'];
    aniofa = json['aniofa'];
    descripcion = json['descripcion'];
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
    vtv = json['vtv'];
    fechaVencVTV = json['fechaVencVTV'];
    vth = json['vth'];
    fechaVencVTH = json['fechaVencVTH'];
    cubiertas = json['cubiertas'];
    correaCinturon = json['correaCinturon'];
    apoyaCabezas = json['apoyaCabezas'];
    limpiavidrios = json['limpiavidrios'];
    espejos = json['espejos'];
    indicadoresDeGiro = json['indicadoresDeGiro'];
    bocina = json['bocina'];
    dispositivoPAT = json['dispositivoPAT'];
    ganchos = json['ganchos'];
    alarmaRetroceso = json['alarmaRetroceso'];
    manguerasCircuitoHidraulico = json['manguerasCircuitoHidraulico'];
    farosDelanteros = json['farosDelanteros'];
    farosTraseros = json['farosTraseros'];
    luzPosicion = json['luzPosicion'];
    luzFreno = json['luzFreno'];
    luzRetroceso = json['luzRetroceso'];
    luzEmergencia = json['luzEmergencia'];
    balizaPortatil = json['balizaPortatil'];
    matafuegos = json['matafuegos'];
    identificadorEmpresa = json['identificadorEmpresa'];
    sobreSalientesPeligro = json['sobreSalientesPeligro'];
    diagramaDeCarga = json['diagramaDeCarga'];
    fajas = json['fajas'];
    grilletes = json['grilletes'];
    cintaSujecionCarga = json['cintaSujecionCarga'];
    jefeDirecto = json['jefeDirecto'];
    responsableVehiculo = json['responsableVehiculo'];
    observaciones = json['observaciones'];
    grupoC = json['grupoC'];
    causanteC = json['causanteC'];
    nombre = json['nombre'];
    dni = json['dni'];
    apellidoNombre = json['apellidoNombre'];
    seguro = json['seguro'];
    fechaVencSeguro = json['fechaVencSeguro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['idCheckList'] = idCheckList;
    data['fecha'] = fecha;
    data['idUser'] = idUser;
    data['idCliente'] = idCliente;
    data['cliente'] = cliente;
    data['idVehiculo'] = idVehiculo;
    data['numcha'] = numcha;
    data['nrotar'] = nrotar;
    data['codProducto'] = codProducto;
    data['aniofa'] = aniofa;
    data['descripcion'] = descripcion;
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
    data['vtv'] = vtv;
    data['fechaVencVTV'] = fechaVencVTV;
    data['vth'] = vth;
    data['fechaVencVTH'] = fechaVencVTH;
    data['cubiertas'] = cubiertas;
    data['correaCinturon'] = correaCinturon;
    data['apoyaCabezas'] = apoyaCabezas;
    data['limpiavidrios'] = limpiavidrios;
    data['espejos'] = espejos;
    data['indicadoresDeGiro'] = indicadoresDeGiro;
    data['bocina'] = bocina;
    data['dispositivoPAT'] = dispositivoPAT;
    data['ganchos'] = ganchos;
    data['alarmaRetroceso'] = alarmaRetroceso;
    data['manguerasCircuitoHidraulico'] = manguerasCircuitoHidraulico;
    data['farosDelanteros'] = farosDelanteros;
    data['farosTraseros'] = farosTraseros;
    data['luzPosicion'] = luzPosicion;
    data['luzFreno'] = luzFreno;
    data['luzRetroceso'] = luzRetroceso;
    data['luzEmergencia'] = luzEmergencia;
    data['balizaPortatil'] = balizaPortatil;
    data['matafuegos'] = matafuegos;
    data['identificadorEmpresa'] = identificadorEmpresa;
    data['sobreSalientesPeligro'] = sobreSalientesPeligro;
    data['diagramaDeCarga'] = diagramaDeCarga;
    data['fajas'] = fajas;
    data['grilletes'] = grilletes;
    data['cintaSujecionCarga'] = cintaSujecionCarga;
    data['jefeDirecto'] = jefeDirecto;
    data['responsableVehiculo'] = responsableVehiculo;
    data['observaciones'] = observaciones;
    data['grupoC'] = grupoC;
    data['causanteC'] = causanteC;
    data['nombre'] = nombre;
    data['dni'] = dni;
    data['apellidoNombre'] = apellidoNombre;
    data['seguro'] = seguro;
    data['fechaVencSeguro'] = fechaVencSeguro;

    return data;
  }
}

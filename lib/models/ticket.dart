class Ticket {
  int nroregistro = 0;
  int? nroobra = 0;
  String? asticket = '';
  String? cliente = '';
  String? direccion = '';
  String? numeracion = '';
  String? localidad = '';
  String? telefono = '';
  String? tipoImput = '';
  String? certificado = '';
  String? serieMedidorColocado = '';
  String? precinto = '';
  String? cajaDAE = '';
  String? observaciones = '';
  String? lindero1 = '';
  String? lindero2 = '';
  String? zona = '';
  String? terminal = '';
  String? subcontratista = '';
  String? causanteC = '';
  String? grxx = '';
  String? gryy = '';
  int? idUsrIn = 0;
  String? observacionAdicional = '';
  String? fechaCarga = '';
  String? riesgoElectrico = '';
  String? fechaasignacion = '';
  int? mes = 0;

  Ticket(
      {required this.nroregistro,
      required this.nroobra,
      required this.asticket,
      required this.cliente,
      required this.direccion,
      required this.numeracion,
      required this.localidad,
      required this.telefono,
      required this.tipoImput,
      required this.certificado,
      required this.serieMedidorColocado,
      required this.precinto,
      required this.cajaDAE,
      required this.observaciones,
      required this.lindero1,
      required this.lindero2,
      required this.zona,
      required this.terminal,
      required this.subcontratista,
      required this.causanteC,
      required this.grxx,
      required this.gryy,
      required this.idUsrIn,
      required this.observacionAdicional,
      required this.fechaCarga,
      required this.riesgoElectrico,
      required this.fechaasignacion,
      required this.mes});

  Ticket.fromJson(Map<String, dynamic> json) {
    nroregistro = json['nroregistro'];
    nroobra = json['nroobra'];
    asticket = json['asticket'];
    cliente = json['cliente'];
    direccion = json['direccion'];
    numeracion = json['numeracion'];
    localidad = json['localidad'];
    telefono = json['telefono'];
    tipoImput = json['tipoImput'];
    certificado = json['certificado'];
    serieMedidorColocado = json['serieMedidorColocado'];
    precinto = json['precinto'];
    cajaDAE = json['cajaDAE'];
    observaciones = json['observaciones'];
    lindero1 = json['lindero1'];
    lindero2 = json['lindero2'];
    zona = json['zona'];
    terminal = json['terminal'];
    subcontratista = json['subcontratista'];
    causanteC = json['causanteC'];
    grxx = json['grxx'];
    gryy = json['gryy'];
    idUsrIn = json['idUsrIn'];
    observacionAdicional = json['observacionAdicional'];
    fechaCarga = json['fechaCarga'];
    riesgoElectrico = json['riesgoElectrico'];
    fechaasignacion = json['fechaasignacion'];
    mes = json['mes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nroregistro'] = this.nroregistro;
    data['nroobra'] = this.nroobra;
    data['asticket'] = this.asticket;
    data['cliente'] = this.cliente;
    data['direccion'] = this.direccion;
    data['numeracion'] = this.numeracion;
    data['localidad'] = this.localidad;
    data['telefono'] = this.telefono;
    data['tipoImput'] = this.tipoImput;
    data['certificado'] = this.certificado;
    data['serieMedidorColocado'] = this.serieMedidorColocado;
    data['precinto'] = this.precinto;
    data['cajaDAE'] = this.cajaDAE;
    data['observaciones'] = this.observaciones;
    data['lindero1'] = this.lindero1;
    data['lindero2'] = this.lindero2;
    data['zona'] = this.zona;
    data['terminal'] = this.terminal;
    data['subcontratista'] = this.subcontratista;
    data['causanteC'] = this.causanteC;
    data['grxx'] = this.grxx;
    data['gryy'] = this.gryy;
    data['idUsrIn'] = this.idUsrIn;
    data['observacionAdicional'] = this.observacionAdicional;
    data['fechaCarga'] = this.fechaCarga;
    data['riesgoElectrico'] = this.riesgoElectrico;
    data['fechaasignacion'] = this.fechaasignacion;
    data['mes'] = this.mes;
    return data;
  }
}

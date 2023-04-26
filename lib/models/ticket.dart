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
  int? idActaCertif = 0;
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
      required this.idActaCertif,
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
    idActaCertif = json['idActaCertif'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroregistro'] = nroregistro;
    data['nroobra'] = nroobra;
    data['asticket'] = asticket;
    data['cliente'] = cliente;
    data['direccion'] = direccion;
    data['numeracion'] = numeracion;
    data['localidad'] = localidad;
    data['telefono'] = telefono;
    data['tipoImput'] = tipoImput;
    data['certificado'] = certificado;
    data['serieMedidorColocado'] = serieMedidorColocado;
    data['precinto'] = precinto;
    data['cajaDAE'] = cajaDAE;
    data['idActaCertif'] = idActaCertif;
    data['observaciones'] = observaciones;
    data['lindero1'] = lindero1;
    data['lindero2'] = lindero2;
    data['zona'] = zona;
    data['terminal'] = terminal;
    data['subcontratista'] = subcontratista;
    data['causanteC'] = causanteC;
    data['grxx'] = grxx;
    data['gryy'] = gryy;
    data['idUsrIn'] = idUsrIn;
    data['observacionAdicional'] = observacionAdicional;
    data['fechaCarga'] = fechaCarga;
    data['riesgoElectrico'] = riesgoElectrico;
    data['fechaasignacion'] = fechaasignacion;
    data['mes'] = mes;
    return data;
  }
}

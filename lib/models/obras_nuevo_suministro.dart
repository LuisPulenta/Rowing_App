class ObrasNuevoSuministro {
  int nrosuministro = 0;
  int nroobra = 0;
  String? fecha = '';
  String? apellidonombre = '';
  String? dni = '';
  String? telefono = '';
  String? email = '';
  String? cuadrilla = '';
  String? grupoc = '';
  String? causantec = '';
  String? directa = '';
  String? domicilio = '';
  String? barrio = '';
  String? localidad = '';
  String? partido = '';
  String? antesfotO1 = '';
  String? antesfotO2 = '';
  String? despuesfotO1 = '';
  String? despuesfotO2 = '';
  String? fotodnifrente = '';
  String? fotodnireverso = '';
  String? firmacliente = '';
  String? entrecalleS1 = '';
  String? entrecalleS2 = '';
  String? medidorcolocado = '';
  String? medidorvecino = '';
  String? tipored = '';
  String? corte = '';
  String? denuncia = '';
  String? enre = '';
  String? otro = '';
  String? conexiondirecta = '';
  String? retiroconexion = '';
  String? retirocrucecalle = '';
  int? mtscableretirado = 0;
  String? trabajoconhidro = '';
  String? postepodrido = '';
  String? observaciones = '';
  int? potenciacontratada = 0;
  int? tensioncontratada = 0;
  int? kitnro = 0;
  int? idcertifmateriales = 0;
  int? idcertifbaremo = 0;
  int? enviado = 0;
  int? materiales = 0;

  ObrasNuevoSuministro(
      {required this.nrosuministro,
      required this.nroobra,
      required this.fecha,
      required this.apellidonombre,
      required this.dni,
      required this.telefono,
      required this.email,
      required this.cuadrilla,
      required this.grupoc,
      required this.causantec,
      required this.directa,
      required this.domicilio,
      required this.barrio,
      required this.localidad,
      required this.partido,
      required this.antesfotO1,
      required this.antesfotO2,
      required this.despuesfotO1,
      required this.despuesfotO2,
      required this.fotodnifrente,
      required this.fotodnireverso,
      required this.firmacliente,
      required this.entrecalleS1,
      required this.entrecalleS2,
      required this.medidorcolocado,
      required this.medidorvecino,
      required this.tipored,
      required this.corte,
      required this.denuncia,
      required this.enre,
      required this.otro,
      required this.conexiondirecta,
      required this.retiroconexion,
      required this.retirocrucecalle,
      required this.mtscableretirado,
      required this.trabajoconhidro,
      required this.postepodrido,
      required this.observaciones,
      required this.potenciacontratada,
      required this.tensioncontratada,
      required this.kitnro,
      required this.idcertifmateriales,
      required this.idcertifbaremo,
      required this.enviado,
      required this.materiales});

  ObrasNuevoSuministro.fromJson(Map<String, dynamic> json) {
    nrosuministro = json['nrosuministro'];
    nroobra = json['nroobra'];
    fecha = json['fecha'];
    apellidonombre = json['apellidonombre'];
    dni = json['dni'];
    telefono = json['telefono'];
    email = json['email'];
    cuadrilla = json['cuadrilla'];
    grupoc = json['grupoc'];
    causantec = json['causantec'];
    directa = json['directa'];
    domicilio = json['domicilio'];
    barrio = json['barrio'];
    localidad = json['localidad'];
    partido = json['partido'];
    antesfotO1 = json['antesfotO1'];
    antesfotO2 = json['antesfotO2'];
    despuesfotO1 = json['despuesfotO1'];
    despuesfotO2 = json['despuesfotO2'];
    fotodnifrente = json['fotodnifrente'];
    fotodnireverso = json['fotodnireverso'];
    firmacliente = json['firmacliente'];
    entrecalleS1 = json['entrecalleS1'];
    entrecalleS2 = json['entrecalleS2'];
    medidorcolocado = json['medidorcolocado'];
    medidorvecino = json['medidorvecino'];
    tipored = json['tipored'];
    corte = json['corte'];
    denuncia = json['denuncia'];
    enre = json['enre'];
    otro = json['otro'];
    conexiondirecta = json['conexiondirecta'];
    retiroconexion = json['retiroconexion'];
    retirocrucecalle = json['retirocrucecalle'];
    mtscableretirado = json['mtscableretirado'];
    trabajoconhidro = json['trabajoconhidro'];
    postepodrido = json['postepodrido'];
    observaciones = json['observaciones'];
    potenciacontratada = json['potenciacontratada'];
    tensioncontratada = json['tensioncontratada'];
    kitnro = json['kitnro'];
    idcertifmateriales = json['idcertifmateriales'];
    idcertifbaremo = json['idcertifbaremo'];
    enviado = json['enviado'];
    materiales = json['materiales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nrosuministro'] = nrosuministro;
    data['nroobra'] = nroobra;
    data['fecha'] = fecha;
    data['apellidonombre'] = apellidonombre;
    data['dni'] = dni;
    data['telefono'] = telefono;
    data['email'] = email;
    data['cuadrilla'] = cuadrilla;
    data['grupoc'] = grupoc;
    data['causantec'] = causantec;
    data['directa'] = directa;
    data['domicilio'] = domicilio;
    data['barrio'] = barrio;
    data['localidad'] = localidad;
    data['partido'] = partido;
    data['antesfotO1'] = antesfotO1;
    data['antesfotO2'] = antesfotO2;
    data['despuesfotO1'] = despuesfotO1;
    data['despuesfotO2'] = despuesfotO2;
    data['fotodnifrente'] = fotodnifrente;
    data['fotodnireverso'] = fotodnireverso;
    data['firmacliente'] = firmacliente;
    data['entrecalleS1'] = entrecalleS1;
    data['entrecalleS2'] = entrecalleS2;
    data['medidorcolocado'] = medidorcolocado;
    data['medidorvecino'] = medidorvecino;
    data['tipored'] = tipored;
    data['corte'] = corte;
    data['denuncia'] = denuncia;
    data['enre'] = enre;
    data['otro'] = otro;
    data['conexiondirecta'] = conexiondirecta;
    data['retiroconexion'] = retiroconexion;
    data['retirocrucecalle'] = retirocrucecalle;
    data['mtscableretirado'] = mtscableretirado;
    data['trabajoconhidro'] = trabajoconhidro;
    data['postepodrido'] = postepodrido;
    data['observaciones'] = observaciones;
    data['potenciacontratada'] = potenciacontratada;
    data['tensioncontratada'] = tensioncontratada;
    data['kitnro'] = kitnro;
    data['idcertifmateriales'] = idcertifmateriales;
    data['idcertifbaremo'] = idcertifbaremo;
    data['enviado'] = enviado;
    data['materiales'] = materiales;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'nrosuministro': nrosuministro,
      'nroobra': nroobra,
      'fecha': fecha,
      'apellidonombre': apellidonombre,
      'dni': dni,
      'telefono': telefono,
      'email': email,
      'cuadrilla': cuadrilla,
      'grupoc': grupoc,
      'causantec': causantec,
      'directa': directa,
      'domicilio': domicilio,
      'barrio': barrio,
      'localidad': localidad,
      'partido': partido,
      'antesfotO1': antesfotO1,
      'antesfotO2': antesfotO2,
      'despuesfotO1': despuesfotO1,
      'despuesfotO2': despuesfotO2,
      'fotodnifrente': fotodnifrente,
      'fotodnireverso': fotodnireverso,
      'firmacliente': firmacliente,
      'entrecalleS1': entrecalleS1,
      'entrecalleS2': entrecalleS2,
      'medidorcolocado': medidorcolocado,
      'medidorvecino': medidorvecino,
      'tipored': tipored,
      'corte': corte,
      'denuncia': denuncia,
      'enre': enre,
      'otro': otro,
      'conexiondirecta': conexiondirecta,
      'retiroconexion': retiroconexion,
      'retirocrucecalle': retirocrucecalle,
      'mtscableretirado': mtscableretirado,
      'trabajoconhidro': trabajoconhidro,
      'postepodrido': postepodrido,
      'observaciones': observaciones,
      'potenciacontratada': potenciacontratada,
      'tensioncontratada': tensioncontratada,
      'kitnro': kitnro,
      'idcertifmateriales': idcertifmateriales,
      'idcertifbaremo': idcertifbaremo,
      'enviado': enviado,
      'materiales': materiales,
    };
  }
}

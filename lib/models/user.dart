class User {
  int idUsuario = 0;
  String codigoCausante = '';
  String login = '';
  String contrasena = '';
  String? nombre = '';
  String? apellido = '';
  int? autorWOM = 0;
  int? estado = 0;
  int? habilitaAPP = 0;
  int? habilitaFotos = 0;
  int? habilitaReclamos = 0;
  int? habilitaSSHH = 0;
  int? habilitaRRHH = 0;
  String modulo = '';
  int? habilitaMedidores = 0;
  String habilitaFlotas = '';
  int? reHabilitaUsuarios = 0;
  String? codigogrupo = '';
  String? codigocausante = '';
  String fullName = '';
  int? fechaCaduca = 0;
  int? intentosInvDiario = 0;
  int? opeAutorizo = 0;
  int? habilitaNuevoSuministro = 0;
  int? habilitaVeredas = 0;
  int? habilitaJuicios = 0;
  int? habilitaPresentismo = 0;
  int? habilitaSeguimientoUsuarios = 0;
  int? habilitaVerObrasCerradas = 0;
  int? habilitaElementosCalle = 0;
  int? habilitaCertificacion = 0;
  int? conceptomov = 0;
  int? conceptomova = 0;
  int? limitarGrupo = 0;
  int? rubro = 0;
  String? firmaUsuario = '';
  String? firmaUsuarioImageFullPath = '';
  String? appIMEI = '';

  User(
      {required this.idUsuario,
      required this.codigoCausante,
      required this.login,
      required this.contrasena,
      required this.nombre,
      required this.apellido,
      required this.autorWOM,
      required this.estado,
      required this.habilitaAPP,
      required this.habilitaFotos,
      required this.habilitaReclamos,
      required this.habilitaSSHH,
      required this.habilitaRRHH,
      required this.modulo,
      required this.habilitaMedidores,
      required this.habilitaFlotas,
      required this.reHabilitaUsuarios,
      required this.codigogrupo,
      required this.codigocausante,
      required this.fullName,
      required this.fechaCaduca,
      required this.intentosInvDiario,
      required this.opeAutorizo,
      required this.habilitaNuevoSuministro,
      required this.habilitaVeredas,
      required this.habilitaJuicios,
      required this.habilitaPresentismo,
      required this.habilitaSeguimientoUsuarios,
      required this.habilitaVerObrasCerradas,
      required this.habilitaElementosCalle,
      required this.habilitaCertificacion,
      required this.conceptomov,
      required this.conceptomova,
      required this.limitarGrupo,
      required this.rubro,
      required this.firmaUsuario,
      required this.firmaUsuarioImageFullPath,
      required this.appIMEI});

  User.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    codigoCausante = json['codigoCausante'];
    login = json['login'];
    contrasena = json['contrasena'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    autorWOM = json['autorWOM'];
    estado = json['estado'];
    habilitaAPP = json['habilitaAPP'];
    habilitaFotos = json['habilitaFotos'];
    habilitaReclamos = json['habilitaReclamos'];
    habilitaSSHH = json['habilitaSSHH'];
    habilitaRRHH = json['habilitaRRHH'];
    modulo = json['modulo'];
    habilitaMedidores = json['habilitaMedidores'];
    habilitaFlotas = json['habilitaFlotas'];
    reHabilitaUsuarios = json['reHabilitaUsuarios'];
    codigogrupo = json['codigogrupo'];
    codigocausante = json['codigocausante'];
    fullName = json['fullName'];
    fechaCaduca = json['fechaCaduca'];
    intentosInvDiario = json['intentosInvDiario'];
    opeAutorizo = json['opeAutorizo'];
    habilitaNuevoSuministro = json['habilitaNuevoSuministro'];
    habilitaVeredas = json['habilitaVeredas'];
    habilitaJuicios = json['habilitaJuicios'];
    habilitaPresentismo = json['habilitaPresentismo'];
    habilitaSeguimientoUsuarios = json['habilitaSeguimientoUsuarios'];
    habilitaVerObrasCerradas = json['habilitaVerObrasCerradas'];
    habilitaElementosCalle = json['habilitaElementosCalle'];
    habilitaCertificacion = json['habilitaCertificacion'];
    conceptomov = json['conceptomov'];
    conceptomova = json['conceptomova'];
    limitarGrupo = json['limitarGrupo'];
    rubro = json['rubro'];
    firmaUsuario = json['firmaUsuario'];
    firmaUsuarioImageFullPath = json['firmaUsuarioImageFullPath'];
    appIMEI = json['appIMEI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idUsuario'] = idUsuario;
    data['codigoCausante'] = codigoCausante;
    data['login'] = login;
    data['contrasena'] = contrasena;
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['autorWOM'] = autorWOM;
    data['estado'] = estado;
    data['habilitaAPP'] = habilitaAPP;
    data['habilitaFotos'] = habilitaFotos;
    data['habilitaReclamos'] = habilitaReclamos;
    data['habilitaSSHH'] = habilitaSSHH;
    data['habilitaRRHH'] = habilitaRRHH;
    data['modulo'] = modulo;
    data['habilitaMedidores'] = habilitaMedidores;
    data['habilitaFlotas'] = habilitaFlotas;
    data['reHabilitaUsuarios'] = reHabilitaUsuarios;
    data['codigogrupo'] = codigogrupo;
    data['codigoCausante'] = codigocausante;
    data['fullName'] = fullName;
    data['fechaCaduca'] = fechaCaduca;
    data['intentosInvDiario'] = intentosInvDiario;
    data['opeAutorizo'] = opeAutorizo;
    data['habilitaNuevoSuministro'] = habilitaNuevoSuministro;
    data['habilitaVeredas'] = habilitaVeredas;
    data['habilitaJuicios'] = habilitaJuicios;
    data['habilitaPresentismo'] = habilitaPresentismo;
    data['habilitaSeguimientoUsuarios'] = habilitaSeguimientoUsuarios;
    data['habilitaVerObrasCerradas'] = habilitaVerObrasCerradas;
    data['habilitaElementosCalle'] = habilitaElementosCalle;
    data['habilitaCertificacion'] = habilitaCertificacion;
    data['conceptomov'] = conceptomov;
    data['conceptomova'] = conceptomova;
    data['limitarGrupo'] = limitarGrupo;
    data['rubro'] = rubro;
    data['firmaUsuario'] = firmaUsuario;
    data['firmaUsuarioImageFullPath'] = firmaUsuarioImageFullPath;
    data['appIMEI'] = appIMEI;
    return data;
  }
}

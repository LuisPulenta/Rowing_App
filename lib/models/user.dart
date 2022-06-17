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
  String? codigogrupo = '';
  String? codigocausante = '';
  String fullName = '';

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
      required this.codigogrupo,
      required this.codigocausante,
      required this.fullName});

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
    codigogrupo = json['codigogrupo'];
    codigocausante = json['codigocausante'];
    fullName = json['fullName'];
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
    data['codigogrupo'] = codigogrupo;
    data['codigoCausante'] = codigocausante;
    data['fullName'] = fullName;

    return data;
  }
}

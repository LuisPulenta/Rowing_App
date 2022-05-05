class User {
  int idUsuario = 0;
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
  String modulo = '';
  int? habilitaMedidores = 0;
  String? codigogrupo = '';
  String? codigocausante = '';
  String fullName = '';

  User(
      {required this.idUsuario,
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
      required this.modulo,
      required this.habilitaMedidores,
      required this.codigogrupo,
      required this.codigocausante,
      required this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
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
    modulo = json['modulo'];
    habilitaMedidores = json['habilitaMedidores'];
    codigogrupo = json['codigogrupo'];
    codigocausante = json['codigocausante'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUsuario'] = this.idUsuario;
    data['login'] = this.login;
    data['contrasena'] = this.contrasena;
    data['nombre'] = this.nombre;
    data['apellido'] = this.apellido;
    data['autorWOM'] = this.autorWOM;
    data['estado'] = this.estado;
    data['habilitaAPP'] = this.habilitaAPP;
    data['habilitaFotos'] = this.habilitaFotos;
    data['habilitaReclamos'] = this.habilitaReclamos;
    data['habilitaSSHH'] = this.habilitaSSHH;
    data['modulo'] = this.modulo;
    data['habilitaMedidores'] = this.habilitaMedidores;
    data['codigogrupo'] = this.codigogrupo;
    data['codigoCausante'] = this.codigocausante;
    data['fullName'] = this.fullName;

    return data;
  }
}

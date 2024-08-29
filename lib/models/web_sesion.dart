class WebSesion {
  int nroConexion = 0;
  String? usuario = '';
  String? iP = '';
  String? loginDate = '';
  int? loginTime = 0;
  String? modulo = '';
  String? logoutDate = '';
  int? logoutTime = 0;
  int? conectAverage = 0;
  int? id_ws = 0;
  String? versionsistema = '';

  WebSesion(
      {required this.nroConexion,
      required this.usuario,
      required this.iP,
      required this.loginDate,
      required this.loginTime,
      required this.modulo,
      required this.logoutDate,
      required this.logoutTime,
      required this.conectAverage,
      required this.id_ws,
      required this.versionsistema});

  WebSesion.fromJson(Map<String, dynamic> json) {
    nroConexion = json['nroConexion'];
    usuario = json['usuario'];
    iP = json['iP'];
    loginDate = json['loginDate'];
    loginTime = json['loginTime'];
    modulo = json['modulo'];
    logoutDate = json['logoutDate'];
    logoutTime = json['logoutTime'];
    conectAverage = json['conectAverage'];
    id_ws = json['id_ws'];
    versionsistema = json['versionsistema'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroConexion'] = nroConexion;
    data['usuario'] = usuario;
    data['iP'] = iP;
    data['loginDate'] = loginDate;
    data['loginTime'] = loginTime;
    data['modulo'] = modulo;
    data['logoutDate'] = logoutDate;
    data['logoutTime'] = logoutTime;
    data['conectAverage'] = conectAverage;
    data['id_ws'] = id_ws;
    data['versionsistema'] = versionsistema;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'nroConexion': nroConexion,
      'usuario': usuario,
      'iP': iP,
      'loginDate': loginDate,
      'loginTime': loginTime,
      'modulo': modulo,
      'logoutDate': logoutDate,
      'logoutTime': logoutTime,
      'conectAverage': conectAverage,
      'id_ws': id_ws,
      'versionsistema': versionsistema,
    };
  }
}

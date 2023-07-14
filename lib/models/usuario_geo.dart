class UsuarioGeo {
  int idUsuario = 0;
  String usuarioStr = '';
  String modulo = '';

  UsuarioGeo(
      {required this.idUsuario,
      required this.usuarioStr,
      required this.modulo});

  UsuarioGeo.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    usuarioStr = json['usuarioStr'];
    modulo = json['modulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idUsuario'] = idUsuario;
    data['usuarioStr'] = usuarioStr;
    data['modulo'] = modulo;
    return data;
  }
}

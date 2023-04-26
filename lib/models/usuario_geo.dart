class UsuarioGeo {
  int idUsuario = 0;
  String usuarioStr = '';

  UsuarioGeo({required this.idUsuario, required this.usuarioStr});

  UsuarioGeo.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    usuarioStr = json['usuarioStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUsuario'] = idUsuario;
    data['usuarioStr'] = usuarioStr;
    return data;
  }
}

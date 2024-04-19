class Mes {
  int nroMes = 0;
  String nombreMes = '';

  Mes({
    required this.nroMes,
    required this.nombreMes,
  });

  Mes.fromJson(Map<String, dynamic> json) {
    nroMes = json['nroMes'];
    nombreMes = json['nombreMes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroMes'] = nroMes;
    data['nombreMes'] = nombreMes;

    return data;
  }
}

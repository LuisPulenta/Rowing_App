class Grupo {
  int nroGrupo = 0;
  String codigo = '';
  String detalle = '';
  int? visualizaAPP = 0;
  bool? habilitado = false;
  int? visualizaSPR = 0;
  int? habilitaRRHH = 0;

  Grupo({
    required this.nroGrupo,
    required this.codigo,
    required this.detalle,
    required this.visualizaAPP,
    required this.habilitado,
    required this.visualizaSPR,
    required this.habilitaRRHH,
  });

  Grupo.fromJson(Map<String, dynamic> json) {
    nroGrupo = json['nroGrupo'];
    codigo = json['codigo'];
    detalle = json['detalle'];
    visualizaAPP = json['visualizaAPP'] ?? 0;
    habilitado = json['habilitado'] ?? false;
    visualizaSPR = json['visualizaSPR'] ?? 0;
    habilitaRRHH = json['habilitaRRHH'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroGrupo'] = nroGrupo;
    data['codigo'] = codigo;
    data['detalle'] = detalle;
    data['visualizaAPP'] = visualizaAPP;
    data['habilitado'] = habilitado;
    data['visualizaSPR'] = visualizaSPR;
    data['habilitaRRHH'] = habilitaRRHH;

    return data;
  }
}

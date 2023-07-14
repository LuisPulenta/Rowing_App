class CausantesEstado {
  String nomencladorestado = '';
  int soloAPP = 0;

  CausantesEstado({required this.nomencladorestado, required this.soloAPP});

  CausantesEstado.fromJson(Map<String, dynamic> json) {
    nomencladorestado = json['nomencladorestado'];
    soloAPP = json['soloAPP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomencladorestado'] = nomencladorestado;
    data['soloAPP'] = soloAPP;
    return data;
  }
}

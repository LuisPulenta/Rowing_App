class TipoNovedad {
  String tipodenovedad = '';

  TipoNovedad({required this.tipodenovedad});

  TipoNovedad.fromJson(Map<String, dynamic> json) {
    tipodenovedad = json['tipodenovedad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tipodenovedad'] = this.tipodenovedad;
    return data;
  }
}

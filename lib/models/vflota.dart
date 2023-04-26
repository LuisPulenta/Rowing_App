class VFlota {
  String numcha = '';
  String grupoV = '';
  String causanteV = '';

  VFlota({required this.numcha, required this.grupoV, required this.causanteV});

  VFlota.fromJson(Map<String, dynamic> json) {
    numcha = json['numcha'];
    grupoV = json['grupoV'];
    causanteV = json['causanteV'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['numcha'] = numcha;
    data['grupoV'] = grupoV;
    data['causanteV'] = causanteV;
    return data;
  }
}

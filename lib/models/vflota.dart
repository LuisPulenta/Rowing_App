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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numcha'] = this.numcha;
    data['grupoV'] = this.grupoV;
    data['causanteV'] = this.causanteV;
    return data;
  }
}

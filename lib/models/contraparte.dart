class Contraparte {
  int idcontraparte = 0;
  String apellidonombre = '';
  String? email = '';
  String? telefono = '';
  String? celular = '';
  String? domicilioestudio = '';
  String? observaciones = '';

  Contraparte(
      {required this.idcontraparte,
      required this.apellidonombre,
      required this.email,
      required this.telefono,
      required this.celular,
      required this.domicilioestudio,
      required this.observaciones});

  Contraparte.fromJson(Map<String, dynamic> json) {
    idcontraparte = json['idcontraparte'];
    apellidonombre = json['apellidonombre'];
    email = json['email'];
    telefono = json['telefono'];
    celular = json['celular'];
    domicilioestudio = json['domicilioestudio'];
    observaciones = json['observaciones'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcontraparte'] = this.idcontraparte;
    data['apellidonombre'] = this.apellidonombre;
    data['email'] = this.email;
    data['telefono'] = this.telefono;
    data['celular'] = this.celular;
    data['domicilioestudio'] = this.domicilioestudio;
    data['observaciones'] = this.observaciones;
    return data;
  }
}

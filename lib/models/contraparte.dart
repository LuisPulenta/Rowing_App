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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idcontraparte'] = idcontraparte;
    data['apellidonombre'] = apellidonombre;
    data['email'] = email;
    data['telefono'] = telefono;
    data['celular'] = celular;
    data['domicilioestudio'] = domicilioestudio;
    data['observaciones'] = observaciones;
    return data;
  }
}

class CausantesZona {
  String nombrezona = '';

  CausantesZona({required this.nombrezona});

  CausantesZona.fromJson(Map<String, dynamic> json) {
    nombrezona = json['nombrezona'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombrezona'] = nombrezona;
    return data;
  }
}

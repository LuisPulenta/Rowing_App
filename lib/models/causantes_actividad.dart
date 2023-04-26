class CausantesActividad {
  String nombreactividad = '';

  CausantesActividad({required this.nombreactividad});

  CausantesActividad.fromJson(Map<String, dynamic> json) {
    nombreactividad = json['nombreactividad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombreactividad'] = nombreactividad;
    return data;
  }
}

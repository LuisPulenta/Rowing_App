class Cliente {
  int nrocliente = 0;
  String nombre = '';

  Cliente({required this.nrocliente, required this.nombre});

  Cliente.fromJson(Map<String, dynamic> json) {
    nrocliente = json['nrocliente'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nrocliente'] = nrocliente;
    data['nombre'] = nombre;
    return data;
  }
}

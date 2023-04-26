class Parametro {
  int id = 0;
  int? bloqueaactas = 0;
  String? ipServ = '';
  int metros = 0;
  int tiempo = 0;

  Parametro(
      {required this.id,
      required this.bloqueaactas,
      required this.ipServ,
      required this.metros,
      required this.tiempo});

  Parametro.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bloqueaactas = json['bloqueaactas'];
    ipServ = json['ipServ'];
    metros = json['metros'];
    tiempo = json['tiempo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['bloqueaactas'] = bloqueaactas;
    data['ipServ'] = ipServ;
    data['metros'] = metros;
    data['tiempo'] = tiempo;
    return data;
  }
}

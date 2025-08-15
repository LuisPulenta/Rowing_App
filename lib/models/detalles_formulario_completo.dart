class DetallesFormularioCompleto {
  int idcliente = 0;
  int idgrupoformulario = 0;
  String descgrupoformulario = '';
  String detallef = '';
  String descripcion = '';
  int ponderacionpuntos = 0;
  String? cumple = '';
  String? foto = '';
  int soloTexto = 0;
  String? obsApp = '';

  DetallesFormularioCompleto(
      {required this.idcliente,
      required this.idgrupoformulario,
      required this.descgrupoformulario,
      required this.detallef,
      required this.descripcion,
      required this.ponderacionpuntos,
      required this.cumple,
      required this.foto,
      required this.soloTexto,
      required this.obsApp});

  DetallesFormularioCompleto.fromJson(Map<String, dynamic> json) {
    idcliente = json['idcliente'];
    idgrupoformulario = json['idgrupoformulario'];
    descgrupoformulario = json['descgrupoformulario'];
    detallef = json['detallef'];
    descripcion = json['descripcion'];
    ponderacionpuntos = json['ponderacionpuntos'];
    cumple = json['cumple'];
    foto = json['foto'];
    soloTexto = json['soloTexto'];
    obsApp = json['obsApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idcliente'] = idcliente;
    data['idgrupoformulario'] = idgrupoformulario;
    data['descgrupoformulario'] = descgrupoformulario;
    data['detallef'] = detallef;
    data['descripcion'] = descripcion;
    data['ponderacionpuntos'] = ponderacionpuntos;
    data['cumple'] = cumple;
    data['foto'] = foto;
    data['soloTexto'] = soloTexto;
    data['obsApp'] = obsApp;
    return data;
  }

  factory DetallesFormularioCompleto.fromMap(Map<String, dynamic> json) =>
      DetallesFormularioCompleto(
        idcliente: json['idcliente'],
        idgrupoformulario: json['idgrupoformulario'],
        descgrupoformulario: json['descgrupoformulario'],
        detallef: json['detallef'],
        descripcion: json['descripcion'],
        ponderacionpuntos: json['ponderacionpuntos'],
        cumple: json['cumple'],
        foto: json['foto'],
        soloTexto: json['soloTexto'],
        obsApp: json['obsApp'],
      );
}

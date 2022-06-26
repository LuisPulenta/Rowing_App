class VehiculosSiniestrosFoto {
  int idfotosiniestro = 0;
  int nrosiniestrocab = 0;
  String observacion = '';
  String linkfoto = '';
  String? imageFullPath = '';

  VehiculosSiniestrosFoto(
      {required this.idfotosiniestro,
      required this.nrosiniestrocab,
      required this.observacion,
      required this.linkfoto,
      required this.imageFullPath});

  VehiculosSiniestrosFoto.fromJson(Map<String, dynamic> json) {
    idfotosiniestro = json['idfotosiniestro'];
    nrosiniestrocab = json['nrosiniestrocab'];
    observacion = json['observacion'];
    linkfoto = json['linkfoto'];
    imageFullPath = json['imageFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idfotosiniestro'] = idfotosiniestro;
    data['nrosiniestrocab'] = nrosiniestrocab;
    data['observacion'] = observacion;
    data['linkfoto'] = linkfoto;
    data['imageFullPath'] = imageFullPath;
    return data;
  }
}

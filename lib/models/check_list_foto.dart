class CheckListFoto {
  int idregistro = 0;
  int idchecklistcab = 0;
  String? descripcion = '';
  String? linkfoto = '';
  String? imageFullPath = '';

  CheckListFoto(
      {required this.idregistro,
      required this.idchecklistcab,
      required this.descripcion,
      required this.linkfoto,
      required this.imageFullPath});

  CheckListFoto.fromJson(Map<String, dynamic> json) {
    idregistro = json['idregistro'];
    idchecklistcab = json['idchecklistcab'];
    descripcion = json['descripcion'];
    linkfoto = json['linkfoto'];
    imageFullPath = json['imageFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idregistro'] = idregistro;
    data['idchecklistcab'] = idchecklistcab;
    data['descripcion'] = descripcion;
    data['linkfoto'] = linkfoto;
    data['imageFullPath'] = imageFullPath;
    return data;
  }
}

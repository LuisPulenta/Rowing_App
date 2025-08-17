class ElemEnCalle {
  int idelementocab = 0;
  int nroobra = 0;
  String nombreObra = '';
  int idusercarga = 0;
  String nombreCarga = '';
  String apellidoCarga = '';
  String fechaCarga = '';
  String grxx = '';
  String gryy = '';
  String domicilio = '';
  String observacion = '';
  String linkfoto = '';
  String imageFullPath = '';
  String estado = '';
  int cantItems = 0;

  ElemEnCalle(
      {required this.idelementocab,
      required this.nroobra,
      required this.nombreObra,
      required this.idusercarga,
      required this.nombreCarga,
      required this.apellidoCarga,
      required this.fechaCarga,
      required this.grxx,
      required this.gryy,
      required this.domicilio,
      required this.observacion,
      required this.linkfoto,
      required this.imageFullPath,
      required this.estado,
      required this.cantItems});

  ElemEnCalle.fromJson(Map<String, dynamic> json) {
    idelementocab = json['idelementocab'];
    nroobra = json['nroobra'];
    nombreObra = json['nombreObra'];
    idusercarga = json['idusercarga'];
    nombreCarga = json['nombreCarga'];
    apellidoCarga = json['apellidoCarga'];
    fechaCarga = json['fechaCarga'];
    grxx = json['grxx'];
    gryy = json['gryy'];
    domicilio = json['domicilio'];
    observacion = json['observacion'];
    linkfoto = json['linkfoto'];
    imageFullPath = json['linkfoto'].toString().isNotEmpty
        ? 'https://gaos2.keypress.com.ar/RowingAppApi${json['linkfoto'].toString().substring(1)}'
        : 'https://gaos2.keypress.com.ar/RowingAppApi/images/ElemEnCalle/noimage.png';
    estado = json['estado'];
    cantItems = json['cantItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idelementocab'] = idelementocab;
    data['nroobra'] = nroobra;
    data['nombreObra'] = nombreObra;
    data['idusercarga'] = idusercarga;
    data['nombreCarga'] = nombreCarga;
    data['apellidoCarga'] = apellidoCarga;
    data['fechaCarga'] = fechaCarga;
    data['grxx'] = grxx;
    data['gryy'] = gryy;
    data['domicilio'] = domicilio;
    data['observacion'] = observacion;
    data['linkfoto'] = linkfoto;
    data['imageFullPath'] = imageFullPath;
    data['estado'] = estado;
    data['cantItems'] = cantItems;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idelementocab': idelementocab,
      'nroobra': nroobra,
      'nombreObra': nombreObra,
      'idusercarga': idusercarga,
      'nombreCarga': nombreCarga,
      'apellidoCarga': apellidoCarga,
      'fechaCarga': fechaCarga,
      'grxx': grxx,
      'gryy': gryy,
      'domicilio': domicilio,
      'observacion': observacion,
      'linkfoto': linkfoto,
      'imageFullPath': imageFullPath,
      'estado': estado,
      'cantItems': cantItems,
    };
  }
}

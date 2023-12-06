class ElemEnCalle {
  int id = 0;
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
  String estado = '';
  int? iduserrecupera = 0;
  String? nombreRecupera = '';
  String? apellidoRecupera = '';
  String? fecharecupero = '';
  String catsiag = '';
  String catsap = '';
  String elemento = '';
  double? cantdejada = 0;
  double? cantrecuperada = 0;
  double? cantPend = 0;

  ElemEnCalle(
      {required this.id,
      required this.idelementocab,
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
      required this.estado,
      required this.iduserrecupera,
      required this.nombreRecupera,
      required this.apellidoRecupera,
      required this.fecharecupero,
      required this.catsiag,
      required this.catsap,
      required this.elemento,
      required this.cantdejada,
      required this.cantrecuperada,
      required this.cantPend});

  ElemEnCalle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    estado = json['estado'];
    iduserrecupera = json['iduserrecupera'];
    nombreRecupera = json['nombreRecupera'];
    apellidoRecupera = json['apellidoRecupera'];
    fecharecupero = json['fecharecupero'];
    catsiag = json['catsiag'];
    catsap = json['catsap'];
    elemento = json['elemento'];
    cantdejada = json['cantdejada'];
    cantrecuperada = json['cantrecuperada'];
    cantPend = json['cantPend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
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
    data['estado'] = estado;
    data['iduserrecupera'] = iduserrecupera;
    data['nombreRecupera'] = nombreRecupera;
    data['apellidoRecupera'] = apellidoRecupera;
    data['fecharecupero'] = fecharecupero;
    data['catsiag'] = catsiag;
    data['catsap'] = catsap;
    data['elemento'] = elemento;
    data['cantdejada'] = cantdejada;
    data['cantrecuperada'] = cantrecuperada;
    data['cantPend'] = cantPend;

    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'estado': estado,
      'iduserrecupera': iduserrecupera,
      'nombreRecupera': nombreRecupera,
      'apellidoRecupera': apellidoRecupera,
      'fecharecupero': fecharecupero,
      'catsiag': catsiag,
      'catsap': catsap,
      'elemento': elemento,
      'cantdejada': cantdejada,
      'cantrecuperada': cantrecuperada,
      'cantPend': cantPend,
    };
  }
}

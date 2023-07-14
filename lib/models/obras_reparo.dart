class ObrasReparo {
  int nroregistro = 0;
  int nroobra = 0;
  String? fechaalta = '';
  String? fechainicio = '';
  String? fechacumplimento = '';
  String? requeridopor = '';
  String? subcontratista = '';
  String? subcontratistareparo = '';
  String? codcausante = '';
  String? nroctoc = '';
  String? direccion = '';
  String? altura = '';
  String? latitud = '';
  String? longitud = '';
  int? codtipostdrparo = 0;
  String? estadosubcon = '';
  String? recursos = '';
  double? montodisponible = 0;
  String? grua = '';
  int? idUsuario = 0;
  String? terminal = '';
  String? observaciones = '';
  String? foto1 = '';
  String? tipoVereda = '';
  int? cantidadMTL = 0;
  int? ancho = 0;
  int? profundidad = 0;
  String? fechaCierreElectrico = '';
  String? imageFullPath = '';
  String? fotoInicio = '';
  String? fotoFin = '';
  String? modulo = '';
  String? observacionesFotoInicio = '';
  String? observacionesFotoFin = '';
  String? fotoInicioFullPath = '';
  String? fotoFinFullPath = '';
  String? clase = '';
  int? ancho2 = 0;
  int? largo2 = 0;

  ObrasReparo(
      {required this.nroregistro,
      required this.nroobra,
      required this.fechaalta,
      required this.fechainicio,
      required this.fechacumplimento,
      required this.requeridopor,
      required this.subcontratista,
      required this.subcontratistareparo,
      required this.codcausante,
      required this.nroctoc,
      required this.direccion,
      required this.altura,
      required this.latitud,
      required this.longitud,
      required this.codtipostdrparo,
      required this.estadosubcon,
      required this.recursos,
      required this.montodisponible,
      required this.grua,
      required this.idUsuario,
      required this.terminal,
      required this.observaciones,
      required this.foto1,
      required this.tipoVereda,
      required this.cantidadMTL,
      required this.ancho,
      required this.profundidad,
      required this.fechaCierreElectrico,
      required this.imageFullPath,
      required this.fotoInicio,
      required this.fotoFin,
      required this.modulo,
      required this.observacionesFotoInicio,
      required this.observacionesFotoFin,
      required this.fotoInicioFullPath,
      required this.fotoFinFullPath,
      required this.clase,
      required this.ancho2,
      required this.largo2});

  ObrasReparo.fromJson(Map<String, dynamic> json) {
    nroregistro = json['nroregistro'];
    nroobra = json['nroobra'];
    fechaalta = json['fechaalta'];
    fechainicio = json['fechainicio'];
    fechacumplimento = json['fechacumplimento'];
    requeridopor = json['requeridopor'];
    subcontratista = json['subcontratista'];
    subcontratistareparo = json['subcontratistareparo'];
    codcausante = json['codcausante'];
    nroctoc = json['nroctoc'];
    direccion = json['direccion'];
    altura = json['altura'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    codtipostdrparo = json['codtipostdrparo'];
    estadosubcon = json['estadosubcon'];
    recursos = json['recursos'];
    montodisponible = json['montodisponible'];
    grua = json['grua'];
    idUsuario = json['idUsuario'];
    terminal = json['terminal'];
    observaciones = json['observaciones'];
    foto1 = json['foto1'];
    tipoVereda = json['tipoVereda'];
    cantidadMTL = json['cantidadMTL'];
    ancho = json['ancho'];
    profundidad = json['profundidad'];
    fechaCierreElectrico = json['fechaCierreElectrico'];
    imageFullPath = json['imageFullPath'];
    fotoInicio = json['fotoInicio'];
    fotoFin = json['fotoFin'];
    modulo = json['modulo'];
    observacionesFotoInicio = json['observacionesFotoInicio'];
    observacionesFotoFin = json['observacionesFotoFin'];
    fotoInicioFullPath = json['fotoInicioFullPath'];
    fotoFinFullPath = json['fotoFinFullPath'];
    clase = json['clase'];
    ancho2 = json['ancho2'];
    largo2 = json['largo2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroregistro'] = nroregistro;
    data['nroobra'] = nroobra;
    data['fechaalta'] = fechaalta;
    data['fechainicio'] = fechainicio;
    data['fechacumplimento'] = fechacumplimento;
    data['requeridopor'] = requeridopor;
    data['subcontratista'] = subcontratista;
    data['subcontratistareparo'] = subcontratistareparo;
    data['codcausante'] = codcausante;
    data['nroctoc'] = nroctoc;
    data['direccion'] = direccion;
    data['altura'] = altura;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['codtipostdrparo'] = codtipostdrparo;
    data['estadosubcon'] = estadosubcon;
    data['recursos'] = recursos;
    data['montodisponible'] = montodisponible;
    data['grua'] = grua;
    data['idUsuario'] = idUsuario;
    data['terminal'] = terminal;
    data['observaciones'] = observaciones;
    data['foto1'] = foto1;
    data['tipoVereda'] = tipoVereda;
    data['cantidadMTL'] = cantidadMTL;
    data['ancho'] = ancho;
    data['profundidad'] = profundidad;
    data['fechaCierreElectrico'] = fechaCierreElectrico;
    data['imageFullPath'] = imageFullPath;
    data['fotoInicio'] = fotoInicio;
    data['fotoFin'] = fotoFin;
    data['modulo'] = modulo;
    data['observacionesFotoInicio'] = observacionesFotoInicio;
    data['observacionesFotoFin'] = observacionesFotoFin;
    data['fotoInicioFullPath'] = fotoInicioFullPath;
    data['fotoFinFullPath'] = fotoFinFullPath;
    data['clase'] = clase;
    data['ancho2'] = ancho2;
    data['largo2'] = largo2;
    return data;
  }
}

import 'obras_documento.dart';

class Obra {
  int nroObra = 0;
  String nombreObra = '';
  String nroOE = '';
  String defProy = '';
  String central = '';
  String elempep = '';
  String? observaciones = '';
  int finalizada = 0;
  String? supervisore = '';
  String? codigoEstado = '';
  String? codigoSubEstado = '';
  String? modulo = '';
  String? grupoAlmacen = '';
  List<ObrasDocumento> obrasDocumentos = [];
  String? fechaCierreElectrico = '';
  String? fechaUltimoMovimiento = '';
  int photos = 0;
  int audios = 0;
  int videos = 0;
  String? posx = '';
  String? posy = '';
  String? direccion = '';
  String? textoLocalizacion = '';
  String? textoClase = '';
  String? textoTipo = '';
  String? textoComponente = '';
  String? codigoDiametro = '';
  String? motivo = '';
  String? planos = '';
  String? grupoCausante = '';

  Obra(
      {required this.nroObra,
      required this.nombreObra,
      required this.nroOE,
      required this.defProy,
      required this.central,
      required this.elempep,
      required this.observaciones,
      required this.finalizada,
      required this.supervisore,
      required this.codigoEstado,
      required this.codigoSubEstado,
      required this.modulo,
      required this.grupoAlmacen,
      required this.obrasDocumentos,
      required this.fechaCierreElectrico,
      required this.fechaUltimoMovimiento,
      required this.photos,
      required this.audios,
      required this.videos,
      required this.posx,
      required this.posy,
      required this.direccion,
      required this.textoLocalizacion,
      required this.textoClase,
      required this.textoTipo,
      required this.textoComponente,
      required this.codigoDiametro,
      required this.motivo,
      required this.planos,
      required this.grupoCausante});

  Obra.fromJson(Map<String, dynamic> json) {
    nroObra = json['nroObra'];
    nombreObra = json['nombreObra'] ?? '';
    nroOE = json['nroOE'] ?? '';
    defProy = json['defProy'] ?? '';
    central = json['central'] ?? '';
    elempep = json['elempep'];
    observaciones = json['observaciones'];
    finalizada = json['finalizada'];
    supervisore = json['supervisore'];
    codigoEstado = json['codigoEstado'];
    codigoSubEstado = json['codigoSubEstado'];
    modulo = json['modulo'];
    grupoAlmacen = json['grupoAlmacen'];
    if (json['obrasDocumentos'] != null) {
      obrasDocumentos = [];
      json['obrasDocumentos'].forEach((v) {
        obrasDocumentos.add(ObrasDocumento.fromJson(v));
      });
    }
    fechaCierreElectrico = json['fechaCierreElectrico'];
    fechaUltimoMovimiento = json['fechaUltimoMovimiento'];
    photos = json['photos'];
    audios = json['audios'];
    videos = json['videos'];
    posx = json['posx'];
    posy = json['posy'];
    direccion = json['direccion'];
    textoLocalizacion = json['textoLocalizacion'];
    textoClase = json['textoClase'];
    textoTipo = json['textoTipo'];
    textoComponente = json['textoComponente'];
    codigoDiametro = json['codigoDiametro'];
    motivo = json['motivo'];
    planos = json['planos'];
    grupoCausante = json['grupoCausante'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroObra'] = nroObra;
    data['nombreObra'] = nombreObra;
    data['nroOE'] = nroOE;
    data['defProy'] = defProy;
    data['central'] = central;
    data['elempep'] = elempep;
    data['observaciones'] = observaciones;
    data['finalizada'] = finalizada;
    data['supervisore'] = supervisore;
    data['codigoEstado'] =
        codigoEstado != null ? codigoEstado!.toUpperCase() : '';
    data['codigoSubEstado'] =
        codigoSubEstado != null ? codigoSubEstado!.toUpperCase() : '';
    data['modulo'] = modulo;
    data['grupoAlmacen'] = grupoAlmacen;
    data['obrasDocumentos'] = obrasDocumentos.map((v) => v.toJson()).toList();
    data['fechaCierreElectrico'] = fechaCierreElectrico;
    data['fechaUltimoMovimiento'] = fechaUltimoMovimiento;
    data['photos'] = photos;
    data['audios'] = audios;
    data['videos'] = videos;
    data['posx'] = posx;
    data['posy'] = posy;
    data['direccion'] = direccion;
    data['textoLocalizacion'] = textoLocalizacion;
    data['textoClase'] = textoClase;
    data['textoTipo'] = textoTipo;
    data['textoComponente'] = textoComponente;
    data['codigoDiametro'] = codigoDiametro;
    data['motivo'] = motivo;
    data['planos'] = planos;
    data['grupoCausante'] = grupoCausante;
    return data;
  }
}

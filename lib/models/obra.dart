import 'package:rowing_app/models/obras_documento.dart';

class Obra {
  int nroObra = 0;
  String nombreObra = '';
  String elempep = '';
  String? observaciones = '';
  int finalizada = 0;
  String? supervisore = '';
  String? codigoEstado = '';
  String? modulo = '';
  String? grupoAlmacen = '';
  List<ObrasDocumento> obrasDocumentos = [];
  String? fechaCierreElectrico = '';

  Obra(
      {required this.nroObra,
      required this.nombreObra,
      required this.elempep,
      required this.observaciones,
      required this.finalizada,
      required this.supervisore,
      required this.codigoEstado,
      required this.modulo,
      required this.grupoAlmacen,
      required this.obrasDocumentos,
      required this.fechaCierreElectrico});

  Obra.fromJson(Map<String, dynamic> json) {
    nroObra = json['nroObra'];
    nombreObra = json['nombreObra'];
    elempep = json['elempep'];
    observaciones = json['observaciones'];
    finalizada = json['finalizada'];
    supervisore = json['supervisore'];
    codigoEstado = json['codigoEstado'];
    modulo = json['modulo'];
    grupoAlmacen = json['grupoAlmacen'];
    if (json['obrasDocumentos'] != null) {
      obrasDocumentos = [];
      json['obrasDocumentos'].forEach((v) {
        obrasDocumentos.add(ObrasDocumento.fromJson(v));
      });
    }
    fechaCierreElectrico = json['fechaCierreElectrico'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroObra'] = nroObra;
    data['nombreObra'] = nombreObra;
    data['elempep'] = elempep;
    data['observaciones'] = observaciones;
    data['finalizada'] = finalizada;
    data['supervisore'] = supervisore;
    data['codigoEstado'] = codigoEstado;
    data['modulo'] = modulo;
    data['grupoAlmacen'] = grupoAlmacen;
    data['obrasDocumentos'] = obrasDocumentos.map((v) => v.toJson()).toList();
    data['fechaCierreElectrico'] = fechaCierreElectrico;
    return data;
  }
}

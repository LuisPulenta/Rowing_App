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
      required this.obrasDocumentos});

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
        obrasDocumentos.add(new ObrasDocumento.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nroObra'] = this.nroObra;
    data['nombreObra'] = this.nombreObra;
    data['elempep'] = this.elempep;
    data['observaciones'] = this.observaciones;
    data['finalizada'] = this.finalizada;
    data['supervisore'] = this.supervisore;
    data['codigoEstado'] = this.codigoEstado;
    data['modulo'] = this.modulo;
    data['grupoAlmacen'] = this.grupoAlmacen;
    if (this.obrasDocumentos != null) {
      data['obrasDocumentos'] =
          this.obrasDocumentos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

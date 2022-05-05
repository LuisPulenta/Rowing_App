class VehiculosProgramaPrev {
  int nroInterno = 0;
  String? codigoDePrograma = '';
  String? codigoDeEquipo = '';
  int? codigoDeParte = 0;
  String? codigoDeTarea = '';
  int? cantFrec = 0;
  String? ultimaLectura = '';
  String? ejecucion = '';
  int? frecDias = 0;
  int? contador = 0;
  String? actualizado = '';
  int? kmDesdeUltimaVerificacion = 0;
  String? frecuencia = '';
  String? estados = '';
  int? diferencia = 0;
  int? proximarev = 0;

  VehiculosProgramaPrev(
      {required this.nroInterno,
      required this.codigoDePrograma,
      required this.codigoDeEquipo,
      required this.codigoDeParte,
      required this.codigoDeTarea,
      required this.cantFrec,
      required this.ultimaLectura,
      required this.ejecucion,
      required this.frecDias,
      required this.contador,
      required this.actualizado,
      required this.kmDesdeUltimaVerificacion,
      required this.frecuencia,
      required this.estados,
      required this.diferencia,
      required this.proximarev});

  VehiculosProgramaPrev.fromJson(Map<String, dynamic> json) {
    nroInterno = json['nroInterno'];
    codigoDePrograma = json['codigoDePrograma'];
    codigoDeEquipo = json['codigoDeEquipo'];
    codigoDeParte = json['codigoDeParte'];
    codigoDeTarea = json['codigoDeTarea'];
    cantFrec = json['cantFrec'];
    ultimaLectura = json['ultimaLectura'];
    ejecucion = json['ejecucion'];
    frecDias = json['frecDias'];
    contador = json['contador'];
    actualizado = json['actualizado'];
    kmDesdeUltimaVerificacion = json['kmDesdeUltimaVerificacion'];
    frecuencia = json['frecuencia'];
    estados = json['estados'];
    diferencia = json['diferencia'];
    proximarev = json['proximarev'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nroInterno'] = this.nroInterno;
    data['codigoDePrograma'] = this.codigoDePrograma;
    data['codigoDeEquipo'] = this.codigoDeEquipo;
    data['codigoDeParte'] = this.codigoDeParte;
    data['codigoDeTarea'] = this.codigoDeTarea;
    data['cantFrec'] = this.cantFrec;
    data['ultimaLectura'] = this.ultimaLectura;
    data['ejecucion'] = this.ejecucion;
    data['frecDias'] = this.frecDias;
    data['contador'] = this.contador;
    data['actualizado'] = this.actualizado;
    data['kmDesdeUltimaVerificacion'] = this.kmDesdeUltimaVerificacion;
    data['frecuencia'] = this.frecuencia;
    data['estados'] = this.estados;
    data['diferencia'] = this.diferencia;
    data['proximarev'] = this.proximarev;
    return data;
  }
}

class ObraNuevoSuministroDet {
  int nroregistrod = 0;
  int nrosuministrocab = 0;
  String catcodigo = '';
  String codigosap = '';
  double cantidad = 0.0;

  ObraNuevoSuministroDet(
      {required this.nroregistrod,
      required this.nrosuministrocab,
      required this.catcodigo,
      required this.codigosap,
      required this.cantidad});

  ObraNuevoSuministroDet.fromJson(Map<String, dynamic> json) {
    nroregistrod = json['nroregistrod'];
    nrosuministrocab = json['nrosuministrocab'];
    catcodigo = json['catcodigo'];
    codigosap = json['codigosap'];
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroregistrod'] = nroregistrod;
    data['nrosuministrocab'] = nrosuministrocab;
    data['catcodigo'] = catcodigo;
    data['codigosap'] = codigosap;
    data['cantidad'] = cantidad;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'nroregistrod': nroregistrod,
      'nrosuministrocab': nrosuministrocab,
      'catcodigo': catcodigo,
      'codigosap': codigosap,
      'cantidad': cantidad,
    };
  }
}

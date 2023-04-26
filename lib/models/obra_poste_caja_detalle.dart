class ObraPosteCajaDetalle {
  int nroregistrod = 0;
  int nroregistrocab = 0;
  String catcodigo = '';
  String codigosap = '';
  double cantidad = 0.0;

  ObraPosteCajaDetalle(
      {required this.nroregistrod,
      required this.nroregistrocab,
      required this.catcodigo,
      required this.codigosap,
      required this.cantidad});

  ObraPosteCajaDetalle.fromJson(Map<String, dynamic> json) {
    nroregistrod = json['nroregistrod'];
    nroregistrocab = json['nroregistrocab'];
    catcodigo = json['catcodigo'];
    codigosap = json['codigosap'];
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroregistrod'] = nroregistrod;
    data['nroregistrocab'] = nroregistrocab;
    data['catcodigo'] = catcodigo;
    data['codigosap'] = codigosap;
    data['cantidad'] = cantidad;
    return data;
  }
}

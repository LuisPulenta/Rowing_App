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
    nroregistrod = json['nroregistrocab'];
    catcodigo = json['catcodigo'];
    codigosap = json['codigosap'];
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nroregistrod'] = this.nroregistrod;
    data['nroregistrocab'] = this.nroregistrocab;
    data['catcodigo'] = this.catcodigo;
    data['codigosap'] = this.codigosap;
    data['cantidad'] = this.cantidad;
    return data;
  }
}

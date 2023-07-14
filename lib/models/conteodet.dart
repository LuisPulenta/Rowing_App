class ConteoDet {
  int idconteodet = 0;
  int idconteocab = 0;
  String codigosiag = '';
  String codigosap = '';
  String descripcion = '';
  double conteoactual = 0;
  double seguninventario = 0;
  double valoractual = 0;

  ConteoDet(
      {required this.idconteodet,
      required this.idconteocab,
      required this.codigosiag,
      required this.codigosap,
      required this.descripcion,
      required this.conteoactual,
      required this.seguninventario,
      required this.valoractual});

  ConteoDet.fromJson(Map<String, dynamic> json) {
    idconteodet = json['idconteodet'];
    idconteocab = json['idconteocab'];
    codigosiag = json['codigosiag'];
    codigosap = json['codigosap'];
    descripcion = json['descripcion'];
    conteoactual = json['conteoactual'];
    seguninventario = json['seguninventario'];
    valoractual = json['valoractual'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idconteodet'] = idconteodet;
    data['idconteocab'] = idconteocab;
    data['codigosiag'] = codigosiag;
    data['codigosap'] = codigosap;
    data['descripcion'] = descripcion;
    data['conteoactual'] = conteoactual;
    data['seguninventario'] = seguninventario;
    data['valoractual'] = valoractual;
    return data;
  }
}

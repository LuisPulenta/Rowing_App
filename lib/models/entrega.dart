class Entrega {
  int identityColumn = 0;
  String codigo = '';
  String grupo = '';
  String causante = '';
  String fecha = '';
  String codigosap = '';
  String denominacion = '';
  double stockAct = 0.0;

  Entrega(
      {required this.identityColumn,
      required this.codigo,
      required this.grupo,
      required this.causante,
      required this.fecha,
      required this.codigosap,
      required this.denominacion,
      required this.stockAct});

  Entrega.fromJson(Map<String, dynamic> json) {
    identityColumn = json['identity_column'];
    codigo = json['codigo'];
    grupo = json['grupo'];
    causante = json['causante'];
    fecha = json['fecha'];
    codigosap = json['codigosap'];
    denominacion = json['denominacion'];
    stockAct = json['stock_act'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identity_column'] = this.identityColumn;
    data['codigo'] = this.codigo;
    data['grupo'] = this.grupo;
    data['causante'] = this.causante;
    data['fecha'] = this.fecha;
    data['codigosap'] = this.codigosap;
    data['denominacion'] = this.denominacion;
    data['stock_act'] = this.stockAct;
    return data;
  }
}

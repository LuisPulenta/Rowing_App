class ElemEnCalleTotales {
  String? catsiag = '';
  String? catsap = '';
  String? elemento = '';
  double? cantdejada = 0.0;

  ElemEnCalleTotales(
      {required this.catsiag,
      required this.catsap,
      required this.elemento,
      required this.cantdejada});

  ElemEnCalleTotales.fromJson(Map<String, dynamic> json) {
    catsiag = json['catsiag'];
    catsap = json['catsap'];
    elemento = json['elemento'];
    cantdejada = json['cantdejada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catsiag'] = catsiag;
    data['catsap'] = catsap;
    data['elemento'] = elemento;
    data['cantdejada'] = cantdejada;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'catsiag': catsiag,
      'catsap': catsap,
      'elemento': elemento,
      'cantdejada': cantdejada,
    };
  }
}

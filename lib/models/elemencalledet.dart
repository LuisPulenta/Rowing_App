class ElemEnCalleDet {
  int id = 0;
  int idelementocab = 0;
  String? catsiag = '';
  String? catsap = '';
  double? cantdejada = 0.0;
  double? cantrecuperada = 0.0;

  ElemEnCalleDet(
      {required this.id,
      required this.idelementocab,
      required this.catsiag,
      required this.catsap,
      required this.cantdejada,
      required this.cantrecuperada});

  ElemEnCalleDet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idelementocab = json['idelementocab'];
    catsiag = json['catsiag'];
    catsap = json['catsap'];
    cantdejada = json['cantdejada'];
    cantrecuperada = json['cantrecuperada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idelementocab'] = idelementocab;
    data['catsiag'] = catsiag;
    data['catsap'] = catsap;
    data['cantdejada'] = cantdejada;
    data['cantrecuperada'] = cantrecuperada;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idelementocab': idelementocab,
      'catsiag': catsiag,
      'catsap': catsap,
      'cantdejada': cantdejada,
      'cantrecuperada': cantrecuperada,
    };
  }
}

class Objeto {
  String objetos = '';
  String modulo = '';

  Objeto({
    required this.objetos,
    required this.modulo,
  });

  Objeto.fromJson(Map<String, dynamic> json) {
    objetos = json['objetos'];
    modulo = json['modulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objetos'] = objetos;
    data['modulo'] = modulo;
    return data;
  }
}

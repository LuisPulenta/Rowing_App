class StandardReparo {
  int codigostd = 0;
  String descripciontarea = '';

  StandardReparo({required this.codigostd, required this.descripciontarea});

  StandardReparo.fromJson(Map<String, dynamic> json) {
    codigostd = json['codigostd'];
    descripciontarea = json['descripciontarea'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codigostd'] = codigostd;
    data['descripciontarea'] = descripciontarea;
    return data;
  }
}

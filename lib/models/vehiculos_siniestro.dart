class VehiculosSiniestro {
  int nrosiniestro = 0;
  String fechacarga = '';
  String grupo = '';
  String causante = '';
  String apellidonombretercero = '';
  String nropolizatercero = '';
  String telefonocontactotercero = '';
  String emailtercero = '';
  String notificadoempresa = '';
  String notificadoa = '';
  String direccionsiniestro = '';
  String altura = '';
  String ciudad = '';
  String provincia = '';
  int horasiniestro = 0;
  String lesionados = '';
  int cantidadlesionados = 0;
  String intervinopolicia = '';
  String intervinoambulancia = '';
  String relatosiniestro = '';
  String numcha = '';
  String companiasegurotercero = '';
  int idusuariocarga = 0;
  String detalledanostercero = '';
  String detalledanospropio = '';
  String numchatercero = '';
  String fechacargaapp = '';
  String? tipoDeSiniestro = '';

  VehiculosSiniestro({
    required this.nrosiniestro,
    required this.fechacarga,
    required this.grupo,
    required this.causante,
    required this.apellidonombretercero,
    required this.nropolizatercero,
    required this.telefonocontactotercero,
    required this.emailtercero,
    required this.notificadoempresa,
    required this.notificadoa,
    required this.direccionsiniestro,
    required this.altura,
    required this.ciudad,
    required this.provincia,
    required this.horasiniestro,
    required this.lesionados,
    required this.cantidadlesionados,
    required this.intervinopolicia,
    required this.intervinoambulancia,
    required this.relatosiniestro,
    required this.numcha,
    required this.companiasegurotercero,
    required this.idusuariocarga,
    required this.detalledanostercero,
    required this.detalledanospropio,
    required this.numchatercero,
    required this.fechacargaapp,
    required this.tipoDeSiniestro,
  });

  VehiculosSiniestro.fromJson(Map<String, dynamic> json) {
    nrosiniestro = json['nrosiniestro'];
    fechacarga = json['fechacarga'];
    grupo = json['grupo'];
    causante = json['causante'];
    apellidonombretercero = json['apellidonombretercero'];
    nropolizatercero = json['nropolizatercero'];
    telefonocontactotercero = json['telefonocontactotercero'];
    emailtercero = json['emailtercero'];
    notificadoempresa = json['notificadoempresa'];
    notificadoa = json['notificadoa'];
    direccionsiniestro = json['direccionsiniestro'];
    altura = json['altura'];
    ciudad = json['ciudad'];
    provincia = json['provincia'];
    horasiniestro = json['horasiniestro'];
    lesionados = json['lesionados'];
    cantidadlesionados = json['cantidadlesionados'];
    intervinopolicia = json['intervinopolicia'];
    intervinoambulancia = json['intervinoambulancia'];
    relatosiniestro = json['relatosiniestro'];
    numcha = json['numcha'];
    companiasegurotercero = json['companiasegurotercero'];
    idusuariocarga = json['idusuariocarga'];
    detalledanostercero = json['detalledanostercero'];
    detalledanospropio = json['detalledanospropio'];
    numchatercero = json['numchatercero'];
    fechacargaapp = json['fechacargaapp'];
    tipoDeSiniestro = json['tipoDeSiniestro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nrosiniestro'] = nrosiniestro;
    data['fechacarga'] = fechacarga;
    data['grupo'] = grupo;
    data['causante'] = causante;
    data['apellidonombretercero'] = apellidonombretercero;
    data['nropolizatercero'] = nropolizatercero;
    data['telefonocontactotercero'] = telefonocontactotercero;
    data['emailtercero'] = emailtercero;
    data['notificadoempresa'] = notificadoempresa;
    data['notificadoa'] = notificadoa;
    data['direccionsiniestro'] = direccionsiniestro;
    data['altura'] = altura;
    data['ciudad'] = ciudad;
    data['provincia'] = provincia;
    data['horasiniestro'] = horasiniestro;
    data['lesionados'] = lesionados;
    data['cantidadlesionados'] = cantidadlesionados;
    data['intervinopolicia'] = intervinopolicia;
    data['intervinoambulancia'] = intervinoambulancia;
    data['relatosiniestro'] = relatosiniestro;
    data['numcha'] = numcha;
    data['companiasegurotercero'] = companiasegurotercero;
    data['idusuariocarga'] = idusuariocarga;
    data['detalledanostercero'] = detalledanostercero;
    data['detalledanospropio'] = detalledanospropio;
    data['numchatercero'] = numchatercero;
    data['fechacargaapp'] = fechacargaapp;
    data['tipoDeSiniestro'] = tipoDeSiniestro;

    return data;
  }
}

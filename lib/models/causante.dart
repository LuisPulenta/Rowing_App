import 'package:camera/camera.dart';

class Causante {
  int nroCausante = 0;
  String codigo = '';
  String nombre = '';
  String? encargado = '';
  String? telefono = '';
  String grupo = '';
  String? nroSAP = '';
  bool? estado = false;
  String? razonSocial = '';
  String? linkFoto = '';
  String? imageFullPath = '';
  XFile? image;
  String? direccion = '';
  int? numero = 0;
  String? telefonoContacto1 = '';
  String? telefonoContacto2 = '';
  String? telefonoContacto3 = '';
  String? fecha = '';
  String? notasCausantes = '';
  String? ciudad = '';
  String? provincia = '';
  int? codigoSupervisorObras = 0;
  String? zonaTrabajo = '';
  String? nombreActividad = '';
  String? notas = '';
  String? presentismo = '';
  String? perteneceCuadrilla = '';
  XFile? firma;
  String? firmaDigitalAPP = '';
  String? firmaFullPath = '';

  Causante({
    required this.nroCausante,
    required this.codigo,
    required this.nombre,
    required this.encargado,
    required this.telefono,
    required this.grupo,
    required this.nroSAP, //DNI
    required this.estado,
    required this.razonSocial,
    required this.linkFoto,
    required this.imageFullPath,
    required this.image,
    required this.direccion,
    required this.numero,
    required this.telefonoContacto1,
    required this.telefonoContacto2,
    required this.telefonoContacto3,
    required this.fecha,
    required this.notasCausantes,
    required this.ciudad,
    required this.provincia,
    required this.codigoSupervisorObras,
    required this.zonaTrabajo,
    required this.nombreActividad,
    required this.notas,
    required this.presentismo,
    required this.perteneceCuadrilla,
    required this.firma,
    required this.firmaDigitalAPP,
    required this.firmaFullPath,
  });

  Causante.fromJson(Map<String, dynamic> json) {
    nroCausante = json['nroCausante'];
    codigo = json['codigo'];
    nombre = json['nombre'];
    encargado = json['encargado'];
    telefono = json['telefono'];
    grupo = json['grupo'];
    nroSAP = json['nroSAP'];
    estado = json['estado'];
    razonSocial = json['razonSocial'];
    linkFoto = json['linkFoto'];
    imageFullPath = json['imageFullPath'];
    image = json['image'];
    direccion = json['direccion'];
    numero = json['numero'];
    telefonoContacto1 = json['telefonoContacto1'];
    telefonoContacto2 = json['telefonoContacto2'];
    telefonoContacto3 = json['telefonoContacto3'];
    fecha = json['fecha'];
    notasCausantes = json['notasCausantes'];
    ciudad = json['ciudad'];
    provincia = json['provincia'];
    codigoSupervisorObras = json['codigoSupervisorObras'];
    zonaTrabajo = json['zonaTrabajo'];
    nombreActividad = json['nombreActividad'];
    notas = json['notas'];
    presentismo = json['presentismo'];
    perteneceCuadrilla = json['perteneceCuadrilla'];
    firma = json['firma'];
    firmaDigitalAPP = json['firmaDigitalAPP'];
    firmaFullPath = json['firmaFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroCausante'] = nroCausante;
    data['codigo'] = codigo;
    data['nombre'] = nombre;
    data['encargado'] = encargado;
    data['telefono'] = telefono;
    data['grupo'] = grupo;
    data['nroSAP'] = nroSAP;
    data['estado'] = estado;
    data['razonSocial'] = razonSocial;
    data['linkFoto'] = linkFoto;
    data['imageFullPath'] = imageFullPath;
    data['image'] = image;
    data['direccion'] = direccion;
    data['numero'] = numero;
    data['telefonoContacto1'] = telefonoContacto1;
    data['telefonoContacto2'] = telefonoContacto2;
    data['telefonoContacto3'] = telefonoContacto3;
    data['fecha'] = fecha;
    data['notasCausantes'] = notasCausantes;
    data['ciudad'] = ciudad;
    data['provincia'] = provincia;
    data['codigoSupervisorObras'] = codigoSupervisorObras;
    data['zonaTrabajo'] = zonaTrabajo;
    data['nombreActividad'] = nombreActividad;
    data['notas'] = notas;
    data['presentismo'] = presentismo;
    data['perteneceCuadrilla'] = perteneceCuadrilla;
    data['firma'] = firma;
    data['firmaDigitalAPP'] = firmaDigitalAPP;
    data['firmaFullPath'] = firmaFullPath;
    return data;
  }
}

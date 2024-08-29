import 'package:rowing_app/models/models.dart';

class Persona {
  Subcontratista subcontratista = Subcontratista(
    subCodigo: '',
    subSubcontratista: '',
    modulo: '',
  );
  Causante causante = Causante(
      nroCausante: 0,
      codigo: '',
      nombre: '',
      encargado: '',
      telefono: '',
      grupo: '',
      nroSAP: '',
      estado: false,
      razonSocial: '',
      linkFoto: '',
      image: null,
      imageFullPath: '',
      direccion: '',
      numero: 0,
      telefonoContacto1: '',
      telefonoContacto2: '',
      telefonoContacto3: '',
      fecha: '',
      notasCausantes: '',
      ciudad: '',
      provincia: '',
      codigoSupervisorObras: 0,
      zonaTrabajo: '',
      nombreActividad: '',
      notas: '',
      presentismo: '',
      perteneceCuadrilla: '',
      firma: null,
      firmaDigitalAPP: '',
      firmaFullPath: '');

  Persona({
    required this.subcontratista,
    required this.causante,
  });

  Persona.fromJson(Map<String, dynamic> json) {
    subcontratista = json['subcontratista'];
    causante = json['causante'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subcontratista'] = subcontratista;
    data['causante'] = causante;
    return data;
  }
}

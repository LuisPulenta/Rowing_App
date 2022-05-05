import 'package:camera/camera.dart';

class Photo {
  XFile image;
  int tipofoto = 0;
  String? observaciones = '';
  double? latitud = 0;
  double? longitud = 0;
  String? direccion = '';

  Photo({
    required this.image,
    required this.tipofoto,
    required this.observaciones,
    required this.latitud,
    required this.longitud,
    required this.direccion,
  });
}

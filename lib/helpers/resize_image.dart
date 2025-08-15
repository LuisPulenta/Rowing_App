import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

Future<Uint8List> resizeImage(
    Uint8List imageBytes, int maxWidth, int maxHeight) async {
  img.Image image = img.decodeImage(imageBytes)!;

  // Calcular la relación de aspecto
  double aspectRatio = image.width / image.height;

  int newWidth = image.width;
  int newHeight = image.height;

  // Si el ancho es mayor que el máximo permitido, ajustamos el ancho y calculamos el alto manteniendo la relación de aspecto
  if (image.width > maxWidth) {
    newWidth = maxWidth;
    newHeight = (maxWidth / aspectRatio).round();
  }

  // Si el alto es mayor que el máximo permitido, ajustamos el alto y calculamos el ancho manteniendo la relación de aspecto
  if (newHeight > maxHeight) {
    newHeight = maxHeight;
    newWidth = (maxHeight * aspectRatio).round();
  }

  // Redimensionar la imagen manteniendo la relación de aspecto
  img.Image resizedImage =
      img.copyResize(image, width: newWidth, height: newHeight);

  // Retornar los bytes de la imagen redimensionada
  return Uint8List.fromList(img.encodeJpg(
      resizedImage)); // Puedes usar encodePng también si prefieres PNG
}

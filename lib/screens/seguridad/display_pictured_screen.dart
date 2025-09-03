import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';

class DisplayPictureDScreen extends StatefulWidget {
  final XFile image;
  final Causante causante;

  const DisplayPictureDScreen({
    super.key,
    required this.image,
    required this.causante,
  });

  @override
  _DisplayPictureDScreenState createState() => _DisplayPictureDScreenState();
}

class _DisplayPictureDScreenState extends State<DisplayPictureDScreen> {
  //---------------------------------------------------------------
  //----------------------- Pantalla -----------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista previa de la foto')),
      body: Column(
        children: [
          Image.file(
            File(widget.image.path),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        return const Color(0xFF120E43);
                      }),
                    ),
                    onPressed: () {
                      _saveRecord();
                      //Navigator.pop(context, response);
                    },
                    child: const Text('Usar Foto'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        return const Color(0xFFE03B8B);
                      }),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Volver a tomar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _saveRecord ---------------------------
  //---------------------------------------------------------------

  Future<void> _saveRecord() async {
    String base64Image = '';

    List<int> imageBytes = await widget.image.readAsBytes();
    base64Image = base64Encode(imageBytes);

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Map<String, dynamic> request = {
      'id': widget.causante.nroCausante,
      'telefono': widget.causante.telefono,
      'direccion': widget.causante.direccion,
      'Numero': widget.causante.numero,
      'TelefonoContacto1': widget.causante.telefonoContacto1,
      'TelefonoContacto2': widget.causante.telefonoContacto2,
      'TelefonoContacto3': widget.causante.telefonoContacto3,
      'fecha': widget.causante.fecha?.toString().substring(0, 10),
      'NotasCausantes': widget.causante.notasCausantes,
      'ciudad': widget.causante.ciudad,
      'Provincia': widget.causante.provincia,
      'ZonaTrabajo': widget.causante.zonaTrabajo,
      'NombreActividad': widget.causante.nombreActividad,
      'image': base64Image,
    };

    Response response = await ApiHelper.put(
      '/api/Causantes/',
      widget.causante.nroCausante.toString(),
      request,
    );

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: response.message,
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    } else {
      await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Guardado con éxito!',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      Navigator.pop(context, 'yes');
    }
  }
}

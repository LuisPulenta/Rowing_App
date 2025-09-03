import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../models/photo.dart';
import '../../models/response.dart';

class DisplayPictureMovScreen extends StatefulWidget {
  final XFile image;

  const DisplayPictureMovScreen({super.key, required this.image});

  @override
  _DisplayPictureMovScreenState createState() =>
      _DisplayPictureMovScreenState();
}

class _DisplayPictureMovScreenState extends State<DisplayPictureMovScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------
  final String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;

  final int _optionId = -1;
  final String _optionIdError = '';
  final bool _optionIdShowError = false;

  //---------------------------------------------------------------------
  //-------------------------- Pantalla --------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista previa de la foto')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              height: 440,
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: 300,
                    height: 440,
                    child: Image.file(
                      File(widget.image.path),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            _showButtons(),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _showButtons -----------------------------
  //---------------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF120E43),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _usePhoto();
              },
              child: const Text('Usar Foto'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE03B8B),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Volver a tomar'),
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------------
  //-------------------------- _usePhoto -----------------------
  //------------------------------------------------------------
  void _usePhoto() async {
    if (_observaciones.length > 100) {
      showAlertDialog(
        context: context,
        title: 'Error',
        message:
            'Las observaciones no pueden superar los 100 caracteres. Ha escrito ${_observaciones.length}.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Photo photo = Photo(
      image: widget.image,
      tipofoto: 0,
      observaciones: _observaciones,
      latitud: 0,
      longitud: 0,
      direccion: '',
    );

    Response response = Response(isSuccess: true, result: photo);
    Navigator.pop(context, response);
  }
}

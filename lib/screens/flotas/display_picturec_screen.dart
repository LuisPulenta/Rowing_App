import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../models/photo.dart';
import '../../models/response.dart';

class DisplayPictureCScreen extends StatefulWidget {
  final XFile image;

  const DisplayPictureCScreen({super.key, required this.image});

  @override
  _DisplayPictureCScreenState createState() => _DisplayPictureCScreenState();
}

class _DisplayPictureCScreenState extends State<DisplayPictureCScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------
  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;

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
            _showObservaciones(),
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

  //---------------------------------------------------------------------
  //-------------------------- _showObservaciones -----------------------
  //---------------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        maxLines: 3,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Observaciones...',
          labelText: 'Observaciones',
          errorText: _observacionesShowError ? _observacionesError : null,
          prefixIcon: const Icon(Icons.list),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _observaciones = value;
        },
      ),
    );
  }

  //------------------------------------------------------------
  //-------------------------- _usePhoto -----------------------
  //------------------------------------------------------------
  void _usePhoto() async {
    if (_observaciones.length > 100) {
      final _ = showAlertDialog(
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

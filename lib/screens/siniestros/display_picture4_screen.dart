import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/models/photo.dart';
import 'package:rowing_app/models/response.dart';

class DisplayPicture4Screen extends StatefulWidget {
  final XFile image;

  const DisplayPicture4Screen({super.key, required this.image});

  @override
  _DisplayPicture4ScreenState createState() => _DisplayPicture4ScreenState();
}

class _DisplayPicture4ScreenState extends State<DisplayPicture4Screen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;

  String _optionId = 'Seleccione un Tipo de Foto...';
  String _optionIdError = '';
  bool _optionIdShowError = false;

  final List<String> _options = [
    'Propio-DNI-Frente',
    'Propio-DNI-Dorso',
    'Propio-Carnet-Frente',
    'Propio-Carnet-Dorso',
    'Propio-Cédula-Frente',
    'Propio-Cédula-Dorso',
    'Propio-Siniestro-Lateral Derecho',
    'Propio-Siniestro-Lateral Izquierdo',
    'Propio-Siniestro-Frente',
    'Propio-Siniestro-Trasero',
    'Tercero-DNI-Frente',
    'Tercero-DNI-Dorso',
    'Tercero-Carnet-Frente',
    'Tercero-Carnet-Dorso',
    'Tercero-Cédula-Frente',
    'Tercero-Cédula-Dorso',
    'Tercero-Seguro-Frente',
    'Tercero-Seguro-Dorso',
    'Tercero-Siniestro-Lateral Derecho',
    'Tercero-Siniestro-Lateral Izquierdo',
    'Tercero-Siniestro-Frente',
    'Tercero-Siniestro-Trasero',
  ];

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

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
            _showOptions(),
            _showObservaciones(),
            _showButtons(),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------------------
  //----------------------- _showOptions --------------------------------
  //---------------------------------------------------------------------

  Widget _showOptions() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        initialValue: _optionId,
        onChanged: (option) {
          setState(() {
            _optionId = option as String;
          });
        },
        items: _getOptions(),
        decoration: InputDecoration(
          hintText: 'Seleccione un Tipo de Foto...',
          labelText: '',
          fillColor: Colors.white,
          filled: true,
          errorText: _optionIdShowError ? _optionIdError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  //---------------------------------------------------------------------
  //----------------------- _showButtons --------------------------------
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
  //----------------------- _showObservaciones --------------------------
  //---------------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Observaciones...',
          labelText: 'Observaciones',
          errorText: _observacionesShowError ? _observacionesError : null,
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _observaciones = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------------
  //----------------------- _usePhoto -----------------------------------
  //---------------------------------------------------------------------

  void _usePhoto() async {
    if (_optionId == 'Seleccione un Tipo de Foto...') {
      _optionIdShowError = true;
      _optionIdError = 'Debe seleccionar un Tipo de Foto';
      setState(() {});
      return;
    } else {
      _optionIdShowError = false;
      setState(() {});
    }

    if (_optionId == -1) {
      return;
    }

    PhotoSiniestro photo = PhotoSiniestro(
      image: widget.image,
      tipofoto: _optionId,
      observaciones: _observaciones,
    );
    Response response = Response(isSuccess: true, result: photo);
    Navigator.pop(context, response);
  }

  //---------------------------------------------------------------------
  //----------------------- _getOptions ---------------------------------
  //---------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getOptions() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Seleccione un Tipo de Foto...',
        child: Text('Seleccione un Tipo de Foto...'),
      ),
    );
    for (var element in _options) {
      list.add(DropdownMenuItem(value: element, child: Text(element)));
    }
    return list;
  }
}

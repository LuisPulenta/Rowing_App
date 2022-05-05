import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/models/option.dart';

class PictureScreen extends StatefulWidget {
  PictureScreen();

  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  String dropdownValue = 'Seleccione un Tipo de Foto...';

  int _optionId = 0;
  String _optionIdError = '';
  bool _optionIdShowError = false;
  List<Option> _options = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8c8c94),
      appBar: AppBar(
        title: Text('Nueva Foto'),
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          // image.path.length == 0
          //     ? Image.asset(
          //         "assets/noimage.png",
          //         width: 320,
          //         height: 320,
          //       )
          //     : Image.file(
          //         File(image.path),
          //         width: MediaQuery.of(context).size.width,
          //         fit: BoxFit.cover,
          //       ),
          SizedBox(height: 5),
          _showOptions(),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Observaciones...',
                  labelText: 'Observaciones',
                  errorText:
                      _observacionesShowError ? _observacionesError : null,
                  prefixIcon: Icon(Icons.text_fields),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _observaciones = value;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _showButtons(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt), onPressed: () async {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _showOptions() {
    return Container(
      padding: EdgeInsets.all(10),
      child: DropdownButtonFormField(
          value: dropdownValue,
          onChanged: (option) {
            setState(() {
              _optionId = option as int;
            });
          },
          items: <String>[
            'Seleccione un Tipo de Foto...',
            'Relevamiento(Vereda/Calzada/Traza)',
            'Previa al trabajo',
            'Durante el trabajo',
            'Finalización del Trabajo'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: 'Seleccione un Tipo de Foto...',
            labelText: '',
            fillColor: Colors.white,
            filled: true,
            errorText: _optionIdShowError ? _optionIdError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Guardar Foto'),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Color(0xFF781f1e);
                }),
              ),
              onPressed: () => _savePhoto(),
            ),
          ),
        ],
      ),
    );
  }

  void _savePhoto() {}
}

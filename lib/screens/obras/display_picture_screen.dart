import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/models/photo.dart';
import 'package:rowing_app/models/response.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class DisplayPictureScreen extends StatefulWidget {
  final XFile image;

  const DisplayPictureScreen({Key? key, required this.image}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;

  int _optionId = -1;
  String _optionIdError = '';
  bool _optionIdShowError = false;

  final List<String> _options = [
    'Relevamiento(Vereda/Calzada/Traza)',
    'Previa al trabajo',
    'Durante el trabajo',
    'Vereda conforme',
    'Finalización del Trabajo',
    'Proceso de geofonía',
    'Proceso de reparación'
  ];

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa de la foto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
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

//---------------------------------------------------------------
//----------------------- _showOptions --------------------------
//---------------------------------------------------------------

  Widget _showOptions() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          value: _optionId,
          onChanged: (option) {
            setState(() {
              _optionId = option as int;
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
          )),
    );
  }

//---------------------------------------------------------------
//----------------------- _showButtons --------------------------
//---------------------------------------------------------------

  Widget _showButtons() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: const Text('Usar Foto'),
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
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                child: const Text('Volver a tomar'),
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
              ),
            ),
          ],
        ));
  }

//---------------------------------------------------------------
//----------------------- _showObservaciones --------------------
//---------------------------------------------------------------

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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _observaciones = value;
        },
      ),
    );
  }

//---------------------------------------------------------------
//----------------------- _usePhoto -----------------------------
//---------------------------------------------------------------

  void _usePhoto() async {
    if (_optionId == -1) {
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

    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Aviso'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('El permiso de localización está negado.'),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok')),
                ],
              );
            });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                        'El permiso de localización está negado permanentemente. No se puede requerir este permiso.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Photo _photo = Photo(
      image: widget.image,
      tipofoto: _optionId,
      observaciones: _observaciones,
      latitud: position.latitude,
      longitud: position.longitude,
      direccion: placemarks[0].street.toString() +
          " - " +
          placemarks[0].locality.toString(),
    );

    Response response = Response(isSuccess: true, result: _photo);
    Navigator.pop(context, response);
  }

  List<DropdownMenuItem<int>> _getOptions() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Seleccione un Tipo de Foto...'),
      value: -1,
    ));
    int nro = 0;
    int _nro = 0;
    for (var element in _options) {
      //CORREGIR EL NUMERO PARA VEREDA CONFORME
      if (nro == 0) {
        _nro = 0;
      }
      if (nro == 1) {
        _nro = 1;
      }
      if (nro == 2) {
        _nro = 2;
      }
      if (nro == 3) {
        _nro = 10;
      }
      if (nro == 4) {
        _nro = 3;
      }
      if (nro == 5) {
        _nro = 5;
      }
      if (nro == 6) {
        _nro = 6;
      }

      list.add(DropdownMenuItem(
        child: Text(element),
        value: _nro,
      ));
      nro++;
    }

    return list;
  }
}

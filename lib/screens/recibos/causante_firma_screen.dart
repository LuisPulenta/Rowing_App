import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class CausanteFirmaScreen extends StatefulWidget {
  final User user;
  const CausanteFirmaScreen({super.key, required this.user});

  @override
  State<CausanteFirmaScreen> createState() => _CausanteFirmaScreenState();
}

class _CausanteFirmaScreenState extends State<CausanteFirmaScreen> {
  //-------------------------- Variables --------------------------
  bool _signatureChanged = false;
  late ByteData? _signature;

  bool _showLoader = false;

  //-------------------------- initState --------------------------
  @override
  void initState() {
    super.initState();
  }

  //----------------------- _checkImageUrl ----------------------------
  Future<Image> _checkImageUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa (200 OK), cargamos la imagen
        return Image.network(url);
      } else {
        // Si la URL no es válida (404, 500, etc.), mostramos la imagen predeterminada
        return Image.asset('assets/errorfirma.png');
      }
    } catch (e) {
      // Si ocurre un error (sin conexión, error en la URL), mostramos la imagen predeterminada
      return Image.asset('assets/errorfirma.png');
    }
  }

  //-------------------------- Pantalla --------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 187, 184, 184),
      appBar: AppBar(
        title: const Text('Mi Firma'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _guardar, icon: const Icon(Icons.save)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 2,
        backgroundColor: const Color(0xFF781f1e),
        onPressed: _takeSignature,
        child: const Icon(Icons.draw, size: 38),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Column(
                  children: [
                    Container(),
                    (widget.user.firmaUsuario == null ||
                            widget.user.firmaUsuario!.isEmpty)
                        ? const Text(
                            'No tiene firma registrada',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(''),
                    const SizedBox(height: 10),
                    Container(
                      child: !_signatureChanged
                          ? widget.user.firmaUsuario == null
                                ? Image(
                                    image: const AssetImage('assets/firma.png'),
                                    width: size.width * 0.8,
                                    height: size.width * 0.8,
                                    fit: BoxFit.contain,
                                  )
                                : FutureBuilder<Image>(
                                    future: _checkImageUrl(
                                      widget.user.firmaUsuarioImageFullPath!,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // Muestra un indicador de carga mientras se espera la imagen
                                        return const FadeInImage(
                                          placeholder: AssetImage(
                                            'assets/loading.gif',
                                          ),
                                          image: AssetImage('assets/firma.png'),
                                        );
                                      } else if (snapshot.hasError ||
                                          !snapshot.hasData) {
                                        // Si la URL no es válida o no está disponible, muestra la imagen predeterminada
                                        return const FadeInImage(
                                          placeholder: AssetImage(
                                            'assets/loading.gif',
                                          ),
                                          image: AssetImage(
                                            'assets/errorfirma.png',
                                          ),
                                        );
                                      } else {
                                        return snapshot.data!;
                                      }
                                    },
                                  )
                          : Image.memory(
                              _signature!.buffer.asUint8List(),
                              width: size.width * 0.8,
                              height: size.width * 0.8,
                            ),
                    ),
                  ],
                ),
                _showLoader
                    ? const LoaderComponent(text: 'Por favor espere...')
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //-------------------------- _takeSignature --------------------
  void _takeSignature() async {
    Response? response = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FirmaScreen()),
    );
    if (response != null) {
      setState(() {
        _signatureChanged = true;
        _signature = response.result;
      });

      //_signature2 = await _signature.toByteData(format: ui.ImageByteFormat.png);
    }
  }

  //-------------------- _guardar ------------------------

  void _guardar() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    String base64ImageUsuarioFirma = '';
    if (_signatureChanged) {
      List<int> imageBytesUsuarioFirma = _signature!.buffer.asUint8List();
      base64ImageUsuarioFirma = base64Encode(imageBytesUsuarioFirma);
    }

    Map<String, dynamic> requestUsuarioFirma = {
      // 'nrosuministro': 0,
      'NroCausante': widget.user.idUsuario,
      'ImageArrayFirmaUsuario': base64ImageUsuarioFirma,
    };

    Response response = await ApiHelper.put(
      '/api/Account3/',
      widget.user.idUsuario.toString(),
      requestUsuarioFirma,
    );

    if (response.isSuccess) {
      _showSnackbar();
    }
  }

  //-------------------------------------------------------------
  //-------------------- _showSnackbar --------------------------
  //-------------------------------------------------------------

  void _showSnackbar() {
    SnackBar snackbar = const SnackBar(
      content: Text('Firma grabada con éxito'),
      backgroundColor: Colors.lightGreen,
      //duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class UsuarioFirmaScreen extends StatefulWidget {
  final User user;
  const UsuarioFirmaScreen({super.key, required this.user});

  @override
  State<UsuarioFirmaScreen> createState() => _UsuarioFirmaScreenState();
}

class _UsuarioFirmaScreenState extends State<UsuarioFirmaScreen> {
  //--------------------------------------------------------------
  //-------------------------- Variable --------------------------
  //--------------------------------------------------------------

  bool _signatureChanged = false;
  late ByteData? _signature;

  bool _showLoader = false;
  //--------------------------------------------------------------
  //-------------------------- initState --------------------------
  //--------------------------------------------------------------
  @override
  void initState() {
    super.initState();
  }

  //--------------------------------------------------------------
  //-------------------------- Pantalla --------------------------
  //--------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Firma Usuario Logueado'),
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
                    Container(
                      child: !_signatureChanged
                          ? widget.user.firmaUsuario == null
                                ? Image(
                                    image: const AssetImage('assets/firma.png'),
                                    width: size.width * 0.8,
                                    height: size.width * 0.8,
                                    fit: BoxFit.contain,
                                  )
                                : FadeInImage(
                                    placeholder: const AssetImage(
                                      'assets/loading.gif',
                                    ),
                                    image: NetworkImage(
                                      widget.user.firmaUsuarioImageFullPath!,
                                    ),
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

  //--------------------------------------------------------------
  //-------------------------- _takeSignature --------------------
  //--------------------------------------------------------------

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

  //------------------------------------------------------
  //-------------------- _guardar ------------------------
  //------------------------------------------------------

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
      'IDUsuario': widget.user.idUsuario,
      'ImageArrayFirmaUsuario': base64ImageUsuarioFirma,
    };

    Response response = await ApiHelper.put(
      '/api/Account2/',
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

import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class PdfScreen extends StatefulWidget {
  final String ruta;
  final Position positionUser;
  final Recibo recibo;
  final Token token;
  final String imei;

  const PdfScreen({
    super.key,
    required this.ruta,
    required this.positionUser,
    required this.recibo,
    required this.token,
    required this.imei,
  });

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  //---------------------- Variables ---------------------------------
  bool _showLoader = false;

  //----------------------- Pantalla ---------------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firmar Recibo'),
        centerTitle: true,
        backgroundColor: const Color(0xff282886),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 350,
            child: PDFView(
              filePath: widget.ruta,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 196, 9, 37),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                await _guardar();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 35),
                  Text('Guardar'),
                ],
              ),
            ),
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

  //-------------------------------------------------------------------
  Future<void> _guardar() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Response response = Response(isSuccess: false);

    Uint8List? fileByte;

    try {
      String myPath = widget.ruta;
      await _readFileByte(myPath).then((bytesData) {
        fileByte = bytesData;
      });
    } catch (e) {}

    Map<String, dynamic> request = {
      'IdRecibo': widget.recibo.idrecibo,
      'Latitud': widget.positionUser.latitude,
      'Longitud': widget.positionUser.longitude,
      'FileName': widget.recibo.link,
      'ImageArray': fileByte,
      'Imei': widget.imei,
    };

    response = await ApiHelper.put3(
      '/api/CausanteRecibos/FirmarRecibo/',
      '${widget.recibo.idrecibo}',
      request,
      widget.token,
    );

    setState(() {
      _showLoader = false;
    });

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
    }

    setState(() {});

    Navigator.pop(context, 'yes');
    Navigator.pop(context, 'yes');
  }

  //---------------------------------------------------------------------------
  Future<Uint8List?> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File file = File.fromUri(myUri);
    Uint8List? bytes;
    await file
        .readAsBytes()
        .then((value) {
          bytes = Uint8List.fromList(value);
        })
        .catchError((onError) {});
    return bytes;
  }
}

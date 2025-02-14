import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/helpers.dart';
import 'package:rowing_app/models/models.dart';

class PdfScreen extends StatefulWidget {
  final String ruta;
  final Position positionUser;
  final Recibo recibo;
  final Token token;

  const PdfScreen(
      {Key? key,
      required this.ruta,
      required this.positionUser,
      required this.recibo,
      required this.token})
      : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
//---------------------- Variables ---------------------------------
  bool _showLoader = false;

//----------------------- Pantalla ---------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firmar Recibo'),
        centerTitle: true,
        backgroundColor: const Color(0xff282886),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.ruta,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 35,
                  ),
                  Text('Guardar'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 196, 9, 37),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                await _guardar();
              },
            ),
          ),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
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
          'Error', "Verifica que estés conectado a Internet", 'Aceptar');
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
    };

    response = await ApiHelper.put3('/api/CausanteRecibos/FirmarRecibo/',
        '${widget.recibo.idrecibo}', request, widget.token);

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
          ]);
      return;
    }

    setState(() {});

    Navigator.pop(context, 'yes');
    Navigator.pop(context, 'yes');
  }

  //---------------------------------------------------------------------------
  Future<Uint8List?> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File file = new File.fromUri(myUri);
    Uint8List? bytes;
    await file.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
    }).catchError((onError) {});
    return bytes;
  }
}

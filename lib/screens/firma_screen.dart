// ignore_for_file: unnecessary_const

import 'dart:ui' as ui;
import 'package:rowing_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class FirmaScreen extends StatefulWidget {
  const FirmaScreen({Key? key}) : super(key: key);

  @override
  _FirmaScreenState createState() => _FirmaScreenState();
}

class _FirmaScreenState extends State<FirmaScreen> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    ui.Image image =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    Response response = Response(isSuccess: true, result: bytes);
    Navigator.pop(context, response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Firma"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          color: const Color(0xFFC7C7C8),
          child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        child: SfSignaturePad(
                            key: signatureGlobalKey,
                            backgroundColor: Colors.white,
                            strokeColor: Colors.black,
                            minimumStrokeWidth: 1.0,
                            maximumStrokeWidth: 4.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)))),
                const SizedBox(height: 10),
                Row(children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.save),
                            SizedBox(
                              width: 12,
                            ),
                            Text('Usar Firma', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF120E43),
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: _handleSaveButtonPressed),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 12,
                          ),
                          Text('Borrar', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFE03B8B),
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: _handleClearButtonPressed,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center),
        ));
  }
}

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/models/models.dart';

class MostrarFotoScreen extends StatefulWidget {
  final XFile image;

  const MostrarFotoScreen({super.key, required this.image});

  @override
  _MostrarFotoScreenState createState() => _MostrarFotoScreenState();
}

class _MostrarFotoScreenState extends State<MostrarFotoScreen> {
//-------------------------------------------------------------
//-------------------------- Pantalla -------------------------
//-------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa de la foto'),
      ),
      body: Column(
        children: [
          Image.file(
            File(widget.image.path),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                          return const Color(0xFF120E43);
                        }),
                      ),
                      onPressed: () {
                        Response response =
                            Response(isSuccess: true, result: widget.image);
                        Navigator.pop(context, response);
                      },
                      child: const Text('Usar Foto'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                          return const Color(0xFFE03B8B);
                        }),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver a tomar'),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

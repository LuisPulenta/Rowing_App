import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../models/response.dart';

class DisplayPictureBScreen extends StatefulWidget {
  final XFile image;

  const DisplayPictureBScreen({super.key, required this.image});

  @override
  _DisplayPictureBScreenState createState() => _DisplayPictureBScreenState();
}

class _DisplayPictureBScreenState extends State<DisplayPictureBScreen> {
  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista previa de la foto')),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF120E43),
                      minimumSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Response response = Response(
                        isSuccess: true,
                        result: widget.image,
                      );
                      Navigator.pop(context, response);
                    },
                    child: const Text('Usar Foto'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE03B8B),
                      minimumSize: const Size(100, 50),
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
          ),
        ],
      ),
    );
  }
}

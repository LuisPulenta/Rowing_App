import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/models/response.dart';

class DisplayPictureBScreen extends StatefulWidget {
  final XFile image;

  const DisplayPictureBScreen({Key? key, required this.image})
      : super(key: key);

  @override
  _DisplayPictureBScreenState createState() => _DisplayPictureBScreenState();
}

class _DisplayPictureBScreenState extends State<DisplayPictureBScreen> {
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
                      child: const Text('Usar Foto'),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF120E43),
                        minimumSize: const Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Response response =
                            Response(isSuccess: true, result: widget.image);
                        Navigator.pop(context, response);
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
                        primary: const Color(0xFFE03B8B),
                        minimumSize: const Size(100, 50),
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
              )),
        ],
      ),
    );
  }
}

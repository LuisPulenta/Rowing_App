import 'package:camera/camera.dart';
import 'package:rowing_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/models/models.dart';

class TakePictureDScreen extends StatefulWidget {
  final CameraDescription camera;
  final Causante causante;

  TakePictureDScreen({required this.camera, required this.causante});

  @override
  _TakePictureDScreenState createState() => _TakePictureDScreenState();
}

class _TakePictureDScreenState extends State<TakePictureDScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.low,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tomar Foto'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            String? response =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DisplayPictureDScreen(
                          image: image,
                          causante: widget.causante,
                        )));
            if (response == 'yes') {
              Navigator.pop(context, response);
            }
          } catch (e) {}
        },
      ),
    );
  }
}

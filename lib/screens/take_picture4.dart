import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/models/response.dart';
import 'package:rowing_app/screens/screens.dart';

class TakePicture4Screen extends StatefulWidget {
  final CameraDescription camera;

  const TakePicture4Screen({Key? key, required this.camera}) : super(key: key);

  @override
  _TakePicture4ScreenState createState() => _TakePicture4ScreenState();
}

class _TakePicture4ScreenState extends State<TakePicture4Screen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tomar Foto'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            Response? response =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DisplayPicture4Screen(
                          image: image,
                        )));
            if (response != null) {
              Navigator.pop(context, response);
            }
          } catch (e) {
            throw Exception('');
          }
        },
      ),
    );
  }
}

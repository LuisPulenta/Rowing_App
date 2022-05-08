import 'package:flutter/material.dart';

class InspeccionCuestionarioScreen extends StatelessWidget {
  const InspeccionCuestionarioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 191, 191),
      appBar: AppBar(
        title: Text('Cuestionario'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('InspeccionCuestionarioScreen'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rowing_app/models/models.dart';

class Elementosencallereporte extends StatefulWidget {
  final User user;
  const Elementosencallereporte({Key? key, required this.user})
      : super(key: key);

  @override
  State<Elementosencallereporte> createState() =>
      _ElementosencallereporteState();
}

class _ElementosencallereporteState extends State<Elementosencallereporte> {
//---------------------------------------------------------------------
//-------------------------- Variables --------------------------------
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//-------------------------- initState --------------------------------
//---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
  }

//---------------------------------------------------------------------
//-------------------------- Pantalla --------------------------------
//---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Elementos en calle reporte'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Elementos en calle reporte'),
      ),
    );
  }
}

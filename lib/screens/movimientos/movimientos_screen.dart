import 'package:flutter/material.dart';
import 'package:rowing_app/models/models.dart';

class MovimientosScreen extends StatefulWidget {
  final User user;
  const MovimientosScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    //_getObras();
  }

//---------------------------------------------------------------
//----------------------- Pantalla -----------------------------
//---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Movimientos'),
      ),
    );
  }
}

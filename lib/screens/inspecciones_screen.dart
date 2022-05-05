import 'package:flutter/material.dart';
import 'package:rowing_app/models/user.dart';

class InspeccionesScreen extends StatefulWidget {
  final User user;
  InspeccionesScreen({required this.user});

  @override
  _InspeccionesScreenState createState() => _InspeccionesScreenState();
}

class _InspeccionesScreenState extends State<InspeccionesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF484848),
      appBar: AppBar(
        title: Text('Inspecciones'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[],
          )
        ],
      ),
    );
  }
}

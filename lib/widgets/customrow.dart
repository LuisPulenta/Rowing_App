import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  IconData? icon;
  final String nombredato;
  final String? dato;
  bool? alert;

  CustomRow({
    super.key,
    this.icon,
    required this.nombredato,
    required this.dato,
    this.alert,
  });

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          icon != null
              ? alert == true
                    ? const Icon(Icons.warning, color: Colors.red)
                    : Icon(icon, color: const Color(0xFF781f1e))
              : Container(),
          const SizedBox(width: 15),
          SizedBox(
            width: ancho * 0.3,
            child: Text(
              nombredato,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF781f1e),
              ),
            ),
          ),
          Expanded(
            child: Text(
              dato != null ? dato.toString() : '',
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

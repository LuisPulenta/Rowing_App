import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final IconData icon;
  final String nombredato;
  final String? dato;
  bool? alert = false;

  CustomRow(
      {required this.icon, required this.nombredato, this.dato, this.alert});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          alert == true
              ? Icon(
                  Icons.warning,
                  color: Colors.red,
                )
              : Icon(
                  icon,
                  color: Color(0xFF781f1e),
                ),
          SizedBox(
            width: 15,
          ),
          Text(
            nombredato,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF781f1e)),
          ),
          Expanded(
            child: Text(
              dato != null ? dato.toString() : '',
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

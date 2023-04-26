import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  IconData? icon;
  final String nombredato;
  final String? dato;
  bool? alert;

  CustomRow(
      {Key? key,
      this.icon,
      required this.nombredato,
      required this.dato,
      this.alert})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          icon != null
              ? alert == true
                  ? const Icon(
                      Icons.warning,
                      color: Colors.red,
                    )
                  : Icon(
                      icon,
                      color: const Color(0xFF781f1e),
                    )
              : Container(),
          const SizedBox(
            width: 15,
          ),
          Text(
            nombredato,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF781f1e)),
          ),
          Expanded(
            child: Text(
              dato != null ? dato.toString() : '',
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/models.dart';

Widget getImage({required User user, double? width, double? height}) {
  if (user.modulo == 'Navitas') {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Image.asset(
        'assets/navitas.png',
        width: width ?? 300,
        height: height ?? 200,
      ),
    );
  }

  return Image.asset(
    'assets/logo.png',
    width: width ?? 300,
    height: height ?? 200,
  );
}

import 'package:flutter/material.dart';
import 'package:rowing_app/main.dart';

void showMyDialog(String title, String message, String textButton) {
  showDialog(
    barrierDismissible: false,
    context: navigatorKey.currentContext!,
    builder: (context) => Center(
      child: Material(
        color: Colors.transparent,
        child: AlertDialog(
          title: Text(title),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(textButton),
            ),
          ],
        ),
      ),
    ),
  );
}

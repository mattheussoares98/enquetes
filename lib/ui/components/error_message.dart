import 'package:flutter/material.dart';

void showErrorMessage({
  required BuildContext context,
  required String error,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(error, textAlign: TextAlign.center),
    ),
  );
}

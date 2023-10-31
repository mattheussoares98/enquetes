import 'package:flutter/material.dart';

void showErrorMessage({
  @required BuildContext context,
  @required String error,
}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(error, textAlign: TextAlign.center),
    ),
  );
}

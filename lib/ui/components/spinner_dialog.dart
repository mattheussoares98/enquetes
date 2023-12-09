import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    builder: (context) => const SimpleDialog(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Aguarde...", textAlign: TextAlign.center),
          ],
        ),
      ],
    ),
    context: context,
    barrierDismissible: false,
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}

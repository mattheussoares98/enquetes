import 'package:flutter/material.dart';

class HeadLine1 extends StatelessWidget {
  const HeadLine1({
    required String text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Login".toUpperCase(),
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}

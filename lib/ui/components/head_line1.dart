import 'package:flutter/material.dart';

class HeadLine1 extends StatelessWidget {
  const HeadLine1({
    super.key,
    required String text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Login".toUpperCase(),
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}

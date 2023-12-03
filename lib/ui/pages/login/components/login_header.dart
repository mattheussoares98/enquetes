import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(100),
      ),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColorDark,
            ],
          ),
        ),
        width: double.infinity,
        child: const Center(
          child: Text("Logo"),
        ),
      ),
    );
  }
}

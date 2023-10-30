import 'dart:async';

import 'package:flutter/material.dart';

import '../pages/pages.dart';

class LoginPresenterPersonal implements LoginPresenter {
  final StreamController<String> emailErrorController =
      StreamController<String>.broadcast();
  final StreamController<String> passwordErrorController =
      StreamController<String>.broadcast();
  final StreamController<bool> isFormValidController =
      StreamController<bool>.broadcast();

  @override
  Stream get isFormValidStream => isFormValidController.stream;

  @override
  Stream<String> get emailErrorStream => emailErrorController.stream;

  @override
  Stream<String> get passwordErrorStream => passwordErrorController.stream;

  @override
  void validateEmail(String email) {}

  @override
  void validatePassword(String password) {}

  @override
  void auth() {}

  @override
  // TODO: implement isLoadingStream
  Stream get isLoadingStream => throw UnimplementedError();
}

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(98, 8, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    return MaterialApp(
      title: "4dev",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        focusColor: primaryColorDark,
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: primaryColorDark,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: primaryColorDark,
          labelStyle: TextStyle(
            color: primaryColor,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorDark),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          alignLabelWithHint: true,
        ),
        buttonTheme: ButtonThemeData(
          colorScheme: const ColorScheme.light(primary: primaryColor),
          buttonColor: primaryColor,
          splashColor: primaryColorLight,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        iconTheme: const IconThemeData(
          color: primaryColorDark,
        ),
      ),
      home: LoginPage(loginPresenter: LoginPresenterPersonal()),
    );
  }
}

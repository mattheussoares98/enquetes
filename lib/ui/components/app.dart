import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(98, 8, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    return MaterialApp(
      title: "4dev",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: primaryColorLight,
        ),
        focusColor: primaryColorDark,
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: primaryColorDark,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: primaryColorDark,
          iconColor: primaryColorLight,
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
        ),
        iconTheme: const IconThemeData(
          color: primaryColorDark,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

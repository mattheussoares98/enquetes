import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'factories/factories.dart';
import '../ui/components/components.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "4dev",
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/login", page: makeLoginPage),
      ],
    );
  }
}

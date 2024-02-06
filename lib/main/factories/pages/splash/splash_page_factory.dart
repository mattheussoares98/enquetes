import 'package:enquetes/ui/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';

import '../../factories.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGetxSplashPresenter());
}

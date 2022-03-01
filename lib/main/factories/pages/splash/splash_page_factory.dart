import 'package:flutter/material.dart';
import '../../../../ui/pages/splash/splash_page.dart';
import '../../factories.dart';

Widget makeSplashPage() {
  return SplashPage(
    presenter: makeGetxSplashPresenter(),
  );
}

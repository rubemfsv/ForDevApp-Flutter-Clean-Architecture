import 'package:flutter/material.dart';
import '../../../../ui/pages/login/login_page.dart';
import '../../factories.dart';

Widget makeLoginPage() {
  return LoginPage(makeGetxLoginPresenter());
}

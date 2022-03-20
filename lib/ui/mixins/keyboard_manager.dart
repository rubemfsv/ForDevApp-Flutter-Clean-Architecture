import 'package:flutter/material.dart';

mixin KeyboardManager {
  void hideKeyboard(BuildContext context) {
    final correctFocus = FocusScope.of(context);
    if (!correctFocus.hasPrimaryFocus) {
      correctFocus.unfocus();
    }
  }
}

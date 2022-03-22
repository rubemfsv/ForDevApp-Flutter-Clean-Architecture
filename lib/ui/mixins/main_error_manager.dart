import 'package:flutter/material.dart';
import '../helpers/errors/ui_error.dart';
import '../components/components.dart';

mixin MainErrorManager {
  void handleMainError(BuildContext context, Stream<UIError?> stream) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(context, error.description);
      }
    });
  }
}

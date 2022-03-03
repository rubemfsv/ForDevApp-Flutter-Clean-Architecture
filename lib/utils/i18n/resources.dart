import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Translations translations = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case 'en_US':
        translations = EnUs();
        break;
      default:
        translations = PtBr();
        break;
    }
  }
}

import 'package:get/get.dart';

mixin SessionManager {
  void handleSession(Stream<bool> stream) {
    stream.listen((isExpired) {
      if (isExpired == true) {
        Get.offAllNamed('/login');
      }
    });
  }
}

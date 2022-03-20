import 'package:get/get.dart';

mixin SessionManager on GetxController {
  final _isSessionExpired = RxBool();

  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;

  set isSessionExpired(bool isExpired) => _isSessionExpired.value = isExpired;
}
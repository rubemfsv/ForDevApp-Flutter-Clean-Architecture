import 'package:get/get.dart';
import '../../../ui/helpers/errors/ui_error.dart';

mixin PasswordErrorManager on GetxController {
  final _passwordError = Rx<UIError>();

  Stream<UIError> get passwordErrorStream => _passwordError.stream;

  set passwordError(UIError value) => _passwordError.value = value;

  get passwordErrorValue => _passwordError.value;
}

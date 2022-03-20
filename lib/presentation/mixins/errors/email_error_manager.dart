import 'package:get/get.dart';
import '../../../ui/helpers/errors/ui_error.dart';

mixin EmailErrorManager {
  final _emailError = Rx<UIError>();

  Stream<UIError> get emailErrorStream => _emailError.stream;

  set emailError(UIError value) => _emailError.value = value;

  get emailErrorValue => _emailError.value;
}

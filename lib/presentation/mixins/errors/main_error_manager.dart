import 'package:get/get.dart';
import '../../../ui/helpers/errors/ui_error.dart';

mixin MainErrorManager on GetxController {
  final _mainError = Rx<UIError>();

  Stream<UIError> get mainErrorStream => _mainError.stream;

  set mainError(UIError value) => _mainError.value = value;
}

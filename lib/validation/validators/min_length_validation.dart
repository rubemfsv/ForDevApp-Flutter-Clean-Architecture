import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int length;

  MinLengthValidation({this.field, this.length});

  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }
}

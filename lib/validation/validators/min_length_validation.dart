import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int length;

  MinLengthValidation({@required this.field, @required this.length});

  ValidationError validate(String value) {
    return value?.length == length
        ? null
        : ValidationError.invalidField;
  }
}

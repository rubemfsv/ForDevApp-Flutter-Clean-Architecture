import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int length;

  List get props => [field, length];

  MinLengthValidation({required this.field, required this.length});

  ValidationError? validate(Map input) {
    return input[field] != null && input[field].length >= length
        ? null
        : ValidationError.invalidField;
  }
}

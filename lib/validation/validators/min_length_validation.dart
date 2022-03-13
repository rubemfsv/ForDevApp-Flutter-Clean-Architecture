import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int length;
  
  List get props => [field, length];

  MinLengthValidation({@required this.field, @required this.length});

  ValidationError validate(String value) {
    return value != null && value.length >= length
        ? null
        : ValidationError.invalidField;
  }
}

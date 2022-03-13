import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hear_mobile/presentation/protocols/protocols.dart';
import 'package:hear_mobile/validation/protocols/protocols.dart';
import 'package:hear_mobile/validation/validators/validators.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  FieldValidationSpy validation3;

  void mockValidation(FieldValidationSpy validation, ValidationError error) {
    when(validation.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('other_field');
    mockValidation(validation1, null);

    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    mockValidation(validation2, null);

    validation3 = FieldValidationSpy();
    when(validation3.field).thenReturn('any_field');
    mockValidation(validation3, null);

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    final error =
        sut.validate(field: 'any_field', input: {'any_field': 'any_value'});

    expect(error, null);
  });

  test('Should return first error', () {
    mockValidation(validation1, ValidationError.requiredField);
    mockValidation(validation2, ValidationError.requiredField);
    mockValidation(validation3, ValidationError.invalidField);

    final error =
        sut.validate(field: 'any_field', input: {'any_field': 'any_value'});

    expect(error, ValidationError.requiredField);
  });
}

import 'package:test/test.dart';
import '../../../lib/validation/validators/validators.dart';
import '../../../lib/presentation/protocols/protocols.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', fieldToCompare: 'other_field');
  });

  test('Should return error if values are not equal', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'other_value',
    };
    expect(sut.validate(formData), ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'any_value',
    };
    expect(sut.validate(formData), null);
  });

  test('Should return null on invalid cases', () {
    expect(sut.validate({'any_field': 'any_value'}), null);
    expect(sut.validate({'other_field': 'any_value'}), null);
    expect(sut.validate({}), null);
  });
}

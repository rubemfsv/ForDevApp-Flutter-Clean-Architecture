import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:hear_mobile/validation/validators/validators.dart';
import 'package:hear_mobile/presentation/protocols/protocols.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if value is not equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });
}

import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:hear_mobile/validation/validators/validators.dart';
import 'package:hear_mobile/presentation/protocols/protocols.dart';

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', length: 5);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });

  test('Should return error if value is less than min length', () {
    expect(sut.validate(faker.randomGenerator.string(4, min: 1)),
        ValidationError.invalidField);
  });
}

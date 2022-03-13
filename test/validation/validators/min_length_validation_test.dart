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
    expect(sut.validate({'any_field': ''}), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate({'any_field': null}), ValidationError.invalidField);
  });

  test('Should return error if value is less than min length', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(4, min: 1)}),
        ValidationError.invalidField);
  });

  test('Should return null if value is equal to min length', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(5, min: 5)}),
        null);
  });

  test('Should return null if value is bigger than min length', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(6, min: 6)}),
        null);
  });
}

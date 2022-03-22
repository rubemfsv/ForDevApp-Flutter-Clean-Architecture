import 'package:test/test.dart';
import '../../../lib/validation/validators/validators.dart';
import '../../../lib/presentation/protocols/protocols.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate({'any_field': ''}), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate({'any_field': null}), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({'any_field': 'rfsv@cesar.school'}), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({'any_field': 'rfsv'}), ValidationError.invalidField);
  });

  test('Should return null on invalid cases', () {
    expect(sut.validate({}), null);
  });
}

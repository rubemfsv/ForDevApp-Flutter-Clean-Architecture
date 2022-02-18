import 'package:test/test.dart';
import 'package:hear_mobile/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('rfsv@cesar.school'), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('rfsv'), 'Campo inválido');
  });
}

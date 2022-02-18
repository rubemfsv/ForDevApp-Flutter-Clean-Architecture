import 'package:test/test.dart';
import 'package:hear_mobile/validation/protocols/field_validation.dart';
import 'package:hear_mobile/validation/validators/validators.dart';

class EmailValidation implements FieldValidation {
  final regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final String field;

  EmailValidation(this.field);

  String validate(String value) {
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);

    return isValid ? null : 'Campo inválido';
  }
}

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

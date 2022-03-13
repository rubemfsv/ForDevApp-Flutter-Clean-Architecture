import 'package:test/test.dart';
import 'package:hear_mobile/main/factories/factories.dart';
import 'package:hear_mobile/validation/validators/validators.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();
    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', length: 4)
    ]);
  });
}

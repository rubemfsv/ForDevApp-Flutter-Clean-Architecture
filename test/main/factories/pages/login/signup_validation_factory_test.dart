import 'package:test/test.dart';
import '../../../../../lib/main/factories/factories.dart';
import '../../../../../lib/validation/validators/validators.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeSignUpValidations();
    expect(validations, [
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', length: 3),
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', length: 4),
      RequiredFieldValidation('passwordConfirmation'),
      CompareFieldsValidation(
          field: 'passwordConfirmation', fieldToCompare: 'password')
    ]);
  });
}

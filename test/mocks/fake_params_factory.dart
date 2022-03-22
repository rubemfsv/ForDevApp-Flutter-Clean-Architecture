import 'package:faker/faker.dart';
import 'package:hear_mobile/domain/usecases/usecases.dart';

class FakeParamsFactory {
  static AddAccountParams makeAddAccountParams() => AddAccountParams(
        name: faker.person.firstName(),
        email: faker.internet.email(),
        password: faker.internet.password(),
        passwordConfirmation: faker.internet.password(),
      );

  static AuthenticationParams makeAuthenticationParams() =>
      AuthenticationParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );
}

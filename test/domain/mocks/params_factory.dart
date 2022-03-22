import 'package:faker/faker.dart';
import '../../../lib/domain/usecases/usecases.dart';

class ParamsFactory {
  static AddAccountParams makeAddAccount() => AddAccountParams(
        name: faker.person.firstName(),
        email: faker.internet.email(),
        password: faker.internet.password(),
        passwordConfirmation: faker.internet.password(),
      );

  static AuthenticationParams makeAuthentication() => AuthenticationParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );
}

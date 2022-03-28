import 'package:mocktail/mocktail.dart';

import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/usecases/usecases.dart';

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => this.auth(any()));

  void mockAuthentication(AccountEntity data) =>
      this.mockAuthenticationCall().thenAnswer((_) async => data);

  void mockAuthenticationError(DomainError error) {
    this.mockAuthenticationCall().thenThrow((error));
  }
}

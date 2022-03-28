import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/domain/usecases/usecases.dart';

class AddAccountSpy extends Mock implements AddAccount {
  When mockAddAccountCall() => when(() => this.add(any()));
  void mockAddAccount(AccountEntity data) =>
      mockAddAccountCall().thenAnswer((_) async => data);
  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow((error));
  }
}

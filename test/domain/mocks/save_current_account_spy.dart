import 'package:mocktail/mocktail.dart';

import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/domain/usecases/usecases.dart';

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {
  SaveCurrentAccountSpy() {
    this.mockSaveCurrentAccount();
  }
  When mockSaveCurrentAccountCall() => when(() => this.save(any()));
  void mockSaveCurrentAccount() =>
      this.mockSaveCurrentAccountCall().thenAnswer((_) async => _);
  void mockSaveCurrentAccountError() =>
      this.mockSaveCurrentAccountCall().thenThrow((DomainError.unexpected));
}

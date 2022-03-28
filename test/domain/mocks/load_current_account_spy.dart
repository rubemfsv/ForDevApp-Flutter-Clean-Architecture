import 'package:mocktail/mocktail.dart';

import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/usecases/usecases.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCurrentAccountCall() => when(() => this.load());
  void mockLoadCurrentAccount({required AccountEntity account}) =>
      this.mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  void mockLoadCurrentError() =>
      this.mockLoadCurrentAccountCall().thenThrow(Exception());
}

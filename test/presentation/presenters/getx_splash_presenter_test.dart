import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/presentation/presenters/presenters.dart';

import '../../mocks/mocks.dart';

void main() {
  late GetxSplashPresenter sut;
  late LoadCurrentAccountSpy loadCurrentAccount;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    loadCurrentAccount.mockLoadCurrentAccount(
        account: EntityFactory.makeAccount());
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/surveys'),
    ));

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on error', () async {
    loadCurrentAccount.mockLoadCurrentError();

    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/login'),
    ));

    await sut.checkAccount(durationInSeconds: 0);
  });
}

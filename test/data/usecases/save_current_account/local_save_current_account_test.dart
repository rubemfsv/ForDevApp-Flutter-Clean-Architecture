import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../lib/domain/helpers/helpers.dart';
import '../../../../lib/domain/entities/entities.dart';
import '../../../../lib/data/usecases/usecases.dart';

import '../../../mocks/mocks.dart';

void main() {
  late SecureCacheStorageSpy saveSecureCacheStorage;
  late LocalSaveCurrentAccount sut;
  late AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });
  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(
        () => saveSecureCacheStorage.save(key: 'token', value: account.token));
  });

  test('Should throw unexpectedError if SaveSecureCacheStorage throws', () {
    saveSecureCacheStorage.mockSaveError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}

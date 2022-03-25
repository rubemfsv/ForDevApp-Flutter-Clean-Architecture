import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../lib/data/usecases/usecases.dart';
import '../../../../lib/domain/entities/entities.dart';
import '../../../../lib/domain/helpers/helpers.dart';

import '../../../mocks/mocks.dart';

void main() {
  late SecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  setUp(() {
    fetchSecureCacheStorage = SecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    fetchSecureCacheStorage.mockFetch(token);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetch('token'));
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token: token));
  });

  test('Should throw UnexPectedError if FetchSecureCacheStorage throws',
      () async {
    fetchSecureCacheStorage.mockFetchError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexPectedError if FetchSecureCacheStorage returns null',
      () async {
    fetchSecureCacheStorage.mockFetch(null);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

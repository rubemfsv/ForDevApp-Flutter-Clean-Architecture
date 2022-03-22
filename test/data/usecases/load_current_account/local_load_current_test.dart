import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../lib/data/cache/cache.dart';
import '../../../../lib/data/usecases/usecases.dart';
import '../../../../lib/domain/entities/entities.dart';
import '../../../../lib/domain/helpers/helpers.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  When mockFetchSecureCall() =>
      when(() => fetchSecureCacheStorage.fetch(any()));

  void mockFetchSecure(String? data) {
    mockFetchSecureCall().thenAnswer((_) async => data);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecure(token);
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
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexPectedError if FetchSecureCacheStorage returns null',
      () async {
    mockFetchSecure(null);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

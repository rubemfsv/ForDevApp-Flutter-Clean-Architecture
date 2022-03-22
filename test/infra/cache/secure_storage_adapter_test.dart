import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
 late FlutterSecureStorageSpy secureStorage;
 late SecureStorageAdapter sut;
 late String key;
 late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('save', () {
    void mockSaveSecureError() {
      when(() => secureStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenThrow(Exception());
    }

    test('Should call save secure with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () {
      mockSaveSecureError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    When mockFetchSecureCall() =>
        when(() => secureStorage.read(key: any(named: 'key')));

    void mockFetchSecure() =>
        mockFetchSecureCall().thenAnswer((_) async => value);

    void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct value', () async {
      await sut.fetch(key);

      verify(() => secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);

      expect(fetchedValue, value);
    });

    test('Should throw if fetch secure throws', () {
      mockFetchSecureError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    void mockDeleteSecureError() =>
        when(() => secureStorage.delete(key: any(named: 'key'))).thenThrow(Exception());

    test('Should call delete with correct value', () async {
      await sut.delete(key);

      verify(() => secureStorage.delete(key: key)).called(1);
    });

    test('Should throw if secureStorage throws', () async {
      mockDeleteSecureError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}

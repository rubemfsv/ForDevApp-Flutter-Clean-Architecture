import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hear_mobile/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageAdapter sut;
  String key;
  dynamic value;
  LocalStorageSpy localStorage;

  void mockDeleteItemError() =>
      when(localStorage.deleteItem(any)).thenThrow(Exception());

  void mockSetItemError() =>
      when(localStorage.setItem(any, any)).thenThrow(Exception());

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(10);
    value = faker.randomGenerator.string(50);
  });

  test('Should call localStorage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(localStorage.deleteItem(key)).called(1);
    verify(localStorage.setItem(key, value)).called(1);
  });

  test('Should throw if deleteItem throws', () async {
    mockDeleteItemError();

    final future = sut.save(key: key, value: value);

    expect(future, throwsA(TypeMatcher<Exception>()));
  });

  test('Should throw if setItem throws', () async {
    mockSetItemError();

    final future = sut.save(key: key, value: value);

    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}

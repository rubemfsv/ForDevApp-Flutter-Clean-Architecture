import 'package:mocktail/mocktail.dart';

import '../../../lib/data/cache/cache.dart';

class SecureCacheStorageSpy extends Mock
    implements
        FetchSecureCacheStorage,
        DeleteSecureCacheStorage,
        SaveSecureCacheStorage {
  SecureCacheStorageSpy() {
    this.mockDelete();
    this.mockSave();
  }

  When mockFetchCall() => when(() => this.fetch(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());

  When mockSaveCall() =>
      when(() => this.save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}

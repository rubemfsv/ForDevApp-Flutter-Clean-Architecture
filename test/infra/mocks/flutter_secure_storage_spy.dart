import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {
  FlutterSecureStorageSpy() {
    this.mockDelete();
    this.mockSave();
  }

  When mockDeleteCall() => when(() => this.delete(key: any(named: 'key')));
  void mockDelete() => this.mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => this.mockDeleteCall().thenThrow(Exception());

  When mockSaveCall() => when(
      () => this.write(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(Exception());

  When mockFetchCall() => when(() => this.read(key: any(named: 'key')));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());
}

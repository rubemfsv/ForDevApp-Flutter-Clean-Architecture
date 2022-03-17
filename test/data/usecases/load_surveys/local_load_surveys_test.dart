import 'package:faker/faker.dart';
import 'package:hear_mobile/domain/helpers/domain_error.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hear_mobile/data/models/models.dart';
import 'package:hear_mobile/domain/entities/entities.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {
    final data = await fetchCacheStorage.fetch('surveys');
    try {
      if (data?.isEmpty != false) throw Exception();

      return data
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
}

void main() {
  LocalLoadSurveys sut;
  FetchCacheStorageSpy fetchCacheStorage;
  List<Map> data;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': faker.date.dateTime().toIso8601String(),
          'didAnswer': faker.randomGenerator.boolean().toString(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': faker.date.dateTime().toIso8601String(),
          'didAnswer': faker.randomGenerator.boolean().toString(),
        }
      ];

  PostExpectation mockFetchCall() => when(fetchCacheStorage.fetch(any));

  void mockFetch(List<Map> list) {
    data = list;
    mockFetchCall().thenAnswer((_) async => data);
  }

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetch(mockValidData());
  });

  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });

  test('Should return a list of surveys on success', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
          id: data[0]['id'],
          question: data[0]['question'],
          dateTime: DateTime.parse(data[0]['date']),
          didAnswer: bool.fromEnvironment(data[0]['didAnswer'])),
      SurveyEntity(
          id: data[1]['id'],
          question: data[1]['question'],
          dateTime: DateTime.parse(data[1]['date']),
          didAnswer: bool.fromEnvironment(data[1]['didAnswer'])),
    ]);
  });

  test('Should throw UnexpectedError if cache is empty', () async {
    mockFetch([]);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache is null', () async {
    mockFetch(null);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache is invalid', () async {
    mockFetch([
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': 'invalid_date',
        'didAnswer': faker.randomGenerator.boolean().toString(),
      }
    ]);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache is incomplete', () async {
    mockFetch([
      {
        'date': faker.date.dateTime().toIso8601String(),
        'didAnswer': faker.randomGenerator.boolean().toString(),
      }
    ]);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

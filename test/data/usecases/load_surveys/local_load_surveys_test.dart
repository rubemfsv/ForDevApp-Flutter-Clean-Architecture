import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../lib/data/usecases/usecases.dart';
import '../../../../lib/domain/entities/entities.dart';
import '../../../../lib/domain/helpers/helpers.dart';

import '../../../mocks/mocks.dart';

void main() {
  late LocalLoadSurveys sut;
  late CacheStorageSpy cacheStorage;
  late List<Map> data;

  setUp(() {
    cacheStorage = CacheStorageSpy();
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);
    data = CacheFactory.makeSurveyList();
    cacheStorage.mockFetch(data);
  });
  group('load', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
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
      cacheStorage.mockFetch([]);
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockFetchError();
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if cache throws', () async {
      cacheStorage.mockFetchError();

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    late List<SurveyEntity> surveys;

    setUp(() {
      surveys = EntityFactory.makeSurveyList();
    });

    test('Should call cacheStorage with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': surveys[0].dateTime.toIso8601String(),
          'didAnswer': surveys[0].didAnswer.toString(),
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': surveys[1].dateTime.toIso8601String(),
          'didAnswer': surveys[1].didAnswer.toString(),
        }
      ];

      await sut.save(surveys);

      verify(() => cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      cacheStorage.mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

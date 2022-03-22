import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../lib/data/usecases/usecases.dart';
import '../../../../lib/domain/entities/entities.dart';
import '../../../../lib/domain/helpers/helpers.dart';

import '../../../mocks/mocks.dart';

void main() {
  late LocalLoadSurveyResult sut;
  late CacheStorageSpy cacheStorage;
  late Map data;
  late String surveyId;

  setUp(() {
    cacheStorage = CacheStorageSpy();
    sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
    surveyId = faker.guid.guid();
    data = CacheFactory.makeSurveyResult();
    cacheStorage.mockFetch(data);
  });

  group('loadBySurvey', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return survey result on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(
        surveyResult,
        SurveyResultEntity(
          surveyId: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
              image: data['answers'][0]['image'],
              answer: data['answers'][0]['answer'],
              isCurrentAnswer:
                  bool.fromEnvironment(data['answers'][0]['isCurrentAnswer']),
              percent: int.parse(data['answers'][0]['percent']),
            ),
            SurveyAnswerEntity(
              answer: data['answers'][1]['answer'],
              isCurrentAnswer:
                  bool.fromEnvironment(data['answers'][1]['isCurrentAnswer']),
              percent: int.parse(data['answers'][1]['percent']),
            ),
          ],
        ),
      );
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockFetch({});
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyResult());
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyResult());
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockFetchError();
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if cache throws', () async {
      cacheStorage.mockFetchError();

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    late SurveyResultEntity surveyResult;

    When mockSaveCall() => when(() =>
        cacheStorage.save(key: any(named: 'key'), value: any(named: 'value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      surveyResult = EntityFactory.makeSurveyResult();
    });

    test('Should call cacheStorage with correct values', () async {
      Map json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'percent': surveyResult.answers[0].percent.toString(),
            'isCurrentAnswer':
                surveyResult.answers[0].isCurrentAnswer.toString()
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'percent': surveyResult.answers[1].percent.toString(),
            'isCurrentAnswer':
                surveyResult.answers[1].isCurrentAnswer.toString()
          }
        ],
      };

      await sut.save(surveyResult: surveyResult);

      verify(() => cacheStorage.save(
          key: 'survey_result/${surveyResult.surveyId}',
          value: json)).called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      mockSaveError();

      final future = sut.save(surveyResult: surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

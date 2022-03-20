import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hear_mobile/data/cache/cache.dart';
import 'package:hear_mobile/data/usecases/usecases.dart';
import 'package:hear_mobile/domain/entities/entities.dart';
import 'package:hear_mobile/domain/helpers/helpers.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('loadBySurvey', () {
    LocalLoadSurveyResult sut;
    CacheStorageSpy cacheStorage;
    Map data;
    String surveyId;

    Map mockValidData() => {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': faker.randomGenerator.boolean().toString(),
              'percent': faker.randomGenerator.integer(100).toString(),
            },
            {
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': faker.randomGenerator.boolean().toString(),
              'percent': faker.randomGenerator.integer(100).toString(),
            }
          ]
        };

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyId = faker.guid.guid();
      mockFetch(mockValidData());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
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
      mockFetch({});
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch({
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percent': 'invalid int'
          }
        ]
      });
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch({'surveyId': faker.guid.guid()});
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    LocalLoadSurveyResult sut;
    CacheStorageSpy cacheStorage;
    Map data;
    String surveyId;

    Map mockValidData() => {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': faker.randomGenerator.boolean().toString(),
              'percent': faker.randomGenerator.integer(100).toString(),
            },
            {
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': faker.randomGenerator.boolean().toString(),
              'percent': faker.randomGenerator.integer(100).toString(),
            }
          ]
        };

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyId = faker.guid.guid();
      mockFetch(mockValidData());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch({
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percent': 'invalid int'
          }
        ]
      });

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch({'surveyId': faker.guid.guid()});

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if cache throws', () async {
      mockFetchError();

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    LocalLoadSurveyResult sut;
    CacheStorageSpy cacheStorage;
    SurveyResultEntity surveyResult;
    String surveyId;

    SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
            surveyId: faker.guid.guid(),
            question: faker.lorem.sentence(),
            answers: [
              SurveyAnswerEntity(
                image: faker.internet.httpUrl(),
                answer: faker.lorem.sentence(),
                isCurrentAnswer: faker.randomGenerator.boolean(),
                percent: faker.randomGenerator.integer(100),
              ),
              SurveyAnswerEntity(
                answer: faker.lorem.sentence(),
                isCurrentAnswer: faker.randomGenerator.boolean(),
                percent: faker.randomGenerator.integer(100),
              ),
            ]);

    PostExpectation mockSaveCall() =>
        when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyId = faker.guid.guid();
      surveyResult = mockSurveyResult();
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

      await sut.save(surveyId: surveyId, surveyResult: surveyResult);

      verify(cacheStorage.save(key: 'survey_result/$surveyId', value: json))
          .called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      mockSaveError();

      final future = sut.save(surveyId: surveyId, surveyResult: surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

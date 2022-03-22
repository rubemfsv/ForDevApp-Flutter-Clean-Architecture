import 'package:faker/faker.dart';
import 'package:hear_mobile/domain/entities/entities.dart';
import 'package:hear_mobile/ui/pages/pages.dart';

class FakeSurveysFactory {
  static List<Map> makeCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'didAnswer': faker.randomGenerator.boolean().toString(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': faker.date.dateTime().toIso8601String(),
          'didAnswer': faker.randomGenerator.boolean().toString(),
        }
      ];

  static List<Map> makeInvalidCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid_date',
          'didAnswer': faker.randomGenerator.boolean().toString(),
        }
      ];

  static List<Map> makeIncompleteCacheJson() => [
        {
          'date': faker.date.dateTime().toIso8601String(),
          'didAnswer': faker.randomGenerator.boolean().toString(),
        }
      ];

  static List<SurveyEntity> makeEntities() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: faker.date.dateTime(),
          didAnswer: faker.randomGenerator.boolean(),
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: faker.date.dateTime().toUtc(),
          didAnswer: faker.randomGenerator.boolean(),
        ),
      ];

  static List<SurveyViewModel> makeViewModelList() => [
        SurveyViewModel(
          id: '1',
          question: 'Question 1',
          date: 'Date 1',
          didAnswer: true,
        ),
        SurveyViewModel(
          id: '2',
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: false,
        ),
      ];

  static List<Map> makeApiJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        }
      ];
}

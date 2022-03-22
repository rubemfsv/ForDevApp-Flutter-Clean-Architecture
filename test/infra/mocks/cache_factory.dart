import 'package:faker/faker.dart';

class CacheFactory {
  static Map makeSurveyResult() => {
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

  static Map makeInvalidSurveyResult() => {
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
      };

  static Map makeIncompleteSurveyResult() => {'surveyId': faker.guid.guid()};

  static List<Map> makeSurveyList() => [
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

  static List<Map> makeInvalidSurveyList() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid_date',
          'didAnswer': faker.randomGenerator.boolean().toString(),
        }
      ];

  static List<Map> makeIncompleteSurveyList() => [
        {
          'date': faker.date.dateTime().toIso8601String(),
          'didAnswer': faker.randomGenerator.boolean().toString(),
        }
      ];
}

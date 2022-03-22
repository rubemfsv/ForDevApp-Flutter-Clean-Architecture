import 'package:faker/faker.dart';
import '../../../lib/domain/entities/entities.dart';

class EntityFactory {
  static AccountEntity makeAccount() => AccountEntity(
        token: faker.guid.guid(),
      );

  static SurveyResultEntity makeSurveyResult() => SurveyResultEntity(
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

  static List<SurveyEntity> makeSurveyList() => [
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
}

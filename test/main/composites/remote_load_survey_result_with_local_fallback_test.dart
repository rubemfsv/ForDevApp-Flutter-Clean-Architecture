import 'package:faker/faker.dart';
import 'package:hear_mobile/domain/helpers/domain_error.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hear_mobile/data/usecases/usecases.dart';
import 'package:hear_mobile/domain/entities/entities.dart';
import 'package:hear_mobile/main/composites/composites.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  SurveyResultEntity remoteSurveyResult;
  List<SurveyEntity> localSurveys;
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
        ],
      );

  PostExpectation mockRemoteLoadCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    remoteSurveyResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveyResult);
  }

  setUp(() {
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    surveyId = faker.guid.guid();
    mockRemoteLoad();
  });

  test('Should call remote loadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call localsave with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, surveyResult: remoteSurveyResult))
        .called(1);
  });

  test('Should return remote data', () async {
    final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

    expect(surveyResult, remoteSurveyResult);
  });
}

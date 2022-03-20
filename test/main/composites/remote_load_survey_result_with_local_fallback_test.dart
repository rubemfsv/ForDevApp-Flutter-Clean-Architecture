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
  SurveyResultEntity localSurveyResult;
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

  PostExpectation mockRemoteLoadBySurveyCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoadBySurvey() {
    remoteSurveyResult = mockSurveyResult();
    mockRemoteLoadBySurveyCall().thenAnswer((_) async => remoteSurveyResult);
  }

  void mockRemoteLoadBySurveyError(DomainError error) =>
      mockRemoteLoadBySurveyCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() =>
      when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLocalLoadError() =>
      mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    surveyId = faker.guid.guid();
    mockRemoteLoadBySurvey();
  });

  test('Should call remote loadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call localsave with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyResult: remoteSurveyResult)).called(1);
  });

  test('Should return remote data', () async {
    final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

    expect(surveyResult, remoteSurveyResult);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadBySurveyError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    mockRemoteLoadBySurveyError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);
    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return remote surveys', () async {
    mockRemoteLoadBySurveyError(DomainError.unexpected);

    final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

    expect(surveyResult, localSurveyResult);
  });

  test('Should throw unexpected error if remote and local throws', () async {
    mockRemoteLoadBySurveyError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}

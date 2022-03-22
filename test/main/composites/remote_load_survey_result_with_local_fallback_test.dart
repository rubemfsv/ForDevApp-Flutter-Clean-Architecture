import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/data/usecases/usecases.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/main/composites/composites.dart';

import '../../mocks/mocks.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late SurveyResultEntity remoteSurveyResult;
  late SurveyResultEntity localSurveyResult;
  late String surveyId;

  When mockRemoteLoadBySurveyCall() =>
      when(() => remote.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockRemoteLoadBySurvey() {
    remoteSurveyResult = EntityFactory.makeSurveyResult();
    mockRemoteLoadBySurveyCall().thenAnswer((_) async => remoteSurveyResult);
  }

  void mockRemoteLoadBySurveyError(DomainError error) =>
      mockRemoteLoadBySurveyCall().thenThrow(error);

  When mockLocalLoadCall() =>
      when(() => local.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLocalLoad() {
    localSurveyResult = EntityFactory.makeSurveyResult();
    mockLocalLoadCall().thenAnswer((_) async => localSurveyResult);
  }

  void mockLocalLoadError() =>
      mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    surveyId = faker.guid.guid();
    mockRemoteLoadBySurvey();
    mockLocalLoad();
  });

  test('Should call remote loadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call localsave with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(surveyResult: remoteSurveyResult)).called(1);
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
    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
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

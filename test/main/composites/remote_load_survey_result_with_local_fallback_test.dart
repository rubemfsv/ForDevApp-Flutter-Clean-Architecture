import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/main/composites/composites.dart';

import '../../mocks/mocks.dart';

void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late SurveyResultEntity remoteSurveyResult;
  late SurveyResultEntity localSurveyResult;
  late String surveyId;

  setUp(() {
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    surveyId = faker.guid.guid();
    remoteSurveyResult = EntityFactory.makeSurveyResult();
    remote.mockLoad(remoteSurveyResult);
    localSurveyResult = EntityFactory.makeSurveyResult();
    local.mockLoad(localSurveyResult);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
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
    remote.mockLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    remote.mockLoadError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);
    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return remote surveys', () async {
    remote.mockLoadError(DomainError.unexpected);

    final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

    expect(surveyResult, localSurveyResult);
  });

  test('Should throw unexpected error if remote and local throws', () async {
    remote.mockLoadError(DomainError.unexpected);
    local.mockLoadError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}

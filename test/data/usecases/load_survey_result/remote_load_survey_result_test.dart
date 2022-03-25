import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/domain/entities/entities.dart';
import '../../../../lib/domain/helpers/helpers.dart';
import '../../../../lib/data/http/http.dart';
import '../../../../lib/data/usecases/usecases.dart';

import '../../../mocks/mocks.dart';

void main() {
  late RemoteLoadSurveyResult sut;
  late HttpClientSpy httpClient;
  late String url;
  late Map surveyResult;
  late String surveyId;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);
    surveyId = faker.guid.guid();
    surveyResult = ApiFactory.makeSurveyResultJson();
    httpClient.mockRequest(surveyResult);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return survey result on 200', () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(
      result,
      SurveyResultEntity(
        surveyId: surveyResult['surveyId'],
        question: surveyResult['question'],
        answers: [
          SurveyAnswerEntity(
            image: surveyResult['answers'][0]['image'],
            answer: surveyResult['answers'][0]['answer'],
            isCurrentAnswer: surveyResult['answers'][0]
                ['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][0]['percent'],
          ),
          SurveyAnswerEntity(
            answer: surveyResult['answers'][1]['answer'],
            isCurrentAnswer: surveyResult['answers'][1]
                ['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][1]['percent'],
          ),
        ],
      ),
    );
  });

  test(
      'Should throw UnexpectedError if HpptClient returns 200 with invalid data',
      () async {
    httpClient.mockRequest(ApiFactory.makeInvalidJson());

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HpptClient returns 403', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should throw UnexpectedError if HpptClient returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HpptClient returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}

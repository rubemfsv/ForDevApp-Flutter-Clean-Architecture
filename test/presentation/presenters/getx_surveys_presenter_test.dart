import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hear_mobile/domain/entities/entities.dart';
import 'package:hear_mobile/domain/usecases/usecases.dart';
import 'package:hear_mobile/domain/helpers/domain_error.dart';
import 'package:hear_mobile/presentation/presenters/presenters.dart';
import 'package:hear_mobile/ui/helpers/helpers.dart';
import 'package:hear_mobile/ui/pages/pages.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  LoadSurveysSpy loadSurveys;
  GetxSurveysPresenter sut;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(50),
          didAnswer: faker.randomGenerator.boolean(),
          dateTime: DateTime(2020, 2, 20),
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(50),
          didAnswer: faker.randomGenerator.boolean(),
          dateTime: DateTime(2018, 10, 3),
        )
      ];

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  void mockAccessDeniedError() =>
      mockLoadSurveysCall().thenThrow(DomainError.accessDenied);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveyViewModel(
            id: surveys[0].id,
            question: surveys[0].question,
            date: '20 Fev 2020',
            didAnswer: surveys[0].didAnswer,
          ),
          SurveyViewModel(
            id: surveys[1].id,
            question: surveys[1].question,
            date: '03 Out 2018',
            didAnswer: surveys[1].didAnswer,
          )
        ])));

    await sut.loadData();
  });

  test('Should throw correct errors on failure', () async {
    mockLoadSurveysError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null,
        onError: expectAsync1(
          (error) => expect(error, UIError.unexpected.description),
        ));

    await sut.loadData();
  });

  test('Should emit correct events on access denied', () async {
    mockAccessDeniedError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });

  test('Should go to SurveyResult page on survey click', () async {
    expectLater(sut.navigateToStream,
        emitsInOrder(['/survey_result/any_route', '/survey_result/any_route']));

    sut.goToSurveyResult('any_route');
    sut.goToSurveyResult('any_route');
  });
}

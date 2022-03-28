import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/domain_error.dart';
import '../../../lib/presentation/presenters/presenters.dart';
import '../../../lib/ui/helpers/helpers.dart';
import '../../../lib/ui/pages/pages.dart';

import '../../mocks/mocks.dart';

void main() {
  late LoadSurveysSpy loadSurveys;
  late GetxSurveysPresenter sut;
  late List<SurveyEntity> surveys;

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    surveys = EntityFactory.makeSurveyList();
    loadSurveys.mockLoad(surveys);
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(() => loadSurveys.load()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveyViewModel(
            id: surveys[0].id,
            question: surveys[0].question,
            date: surveys[0].date,
            didAnswer: surveys[0].didAnswer,
          ),
          SurveyViewModel(
            id: surveys[1].id,
            question: surveys[1].question,
            date: surveys[1].date,
            didAnswer: surveys[1].didAnswer,
          )
        ])));

    await sut.loadData();
  });

  test('Should throw correct errors on failure', () async {
    loadSurveys.mockLoadError(DomainError.unexpected);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null,
        onError: expectAsync1(
          (error) => expect(error, UIError.unexpected.description),
        ));

    await sut.loadData();
  });

  test('Should emit correct events on access denied', () async {
    loadSurveys.mockLoadError(DomainError.accessDenied);
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

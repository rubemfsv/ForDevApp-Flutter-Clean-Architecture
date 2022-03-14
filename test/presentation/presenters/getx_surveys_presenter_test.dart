import 'package:faker/faker.dart';
import 'package:hear_mobile/ui/pages/surveys/survey_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hear_mobile/domain/entities/entities.dart';
import 'package:hear_mobile/domain/usecases/usecases.dart';
import 'package:hear_mobile/presentation/presenters/presenters.dart';

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

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    when(loadSurveys.load()).thenAnswer((_) async => surveys);
  }

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
}

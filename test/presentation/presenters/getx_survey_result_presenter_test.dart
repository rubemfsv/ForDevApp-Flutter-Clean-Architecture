import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/usecases/usecases.dart';
import '../../../lib/domain/helpers/domain_error.dart';
import '../../../lib/presentation/presenters/presenters.dart';
import '../../../lib/ui/helpers/helpers.dart';
import '../../../lib/ui/pages/pages.dart';

import '../../mocks/mocks.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  late LoadSurveyResultSpy loadSurveyResult;
  late SaveSurveyResultSpy saveSurveyResult;
  late GetxSurveyResultPresenter sut;
  late SurveyResultEntity loadResult;
  late SurveyResultEntity saveResult;
  late String surveyId;
  late String answer;

  When mockLoadSurveyResultCall() => when(
      () => loadSurveyResult.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => loadResult);
  }

  void mockLoadSurveyResultError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);

  void mockLoadAccessDeniedError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);

  When mockSaveSurveyResultCall() =>
      when(() => saveSurveyResult.save(answer: any(named: 'answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError() =>
      mockSaveSurveyResultCall().thenThrow(DomainError.unexpected);

  void mockSaveAccessDeniedError() =>
      mockSaveSurveyResultCall().thenThrow(DomainError.accessDenied);

  setUp(() {
    surveyId = faker.guid.guid();
    loadSurveyResult = LoadSurveyResultSpy();
    saveSurveyResult = SaveSurveyResultSpy();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId,
    );
    answer = faker.lorem.sentence();
    mockLoadSurveyResult(EntityFactory.makeSurveyResult());
    mockSaveSurveyResult(EntityFactory.makeSurveyResult());
  });

  group('loadData', () {
    test('Should call LoadSurveyResult on loadData', () async {
      await sut.loadData();

      verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) => expect(
            result,
            SurveyResultViewModel(
              surveyId: loadResult.surveyId,
              question: loadResult.question,
              answers: [
                SurveyAnswerViewModel(
                  image: loadResult.answers[0].image,
                  answer: loadResult.answers[0].answer,
                  isCurrentAnswer: loadResult.answers[0].isCurrentAnswer,
                  percent: '${loadResult.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  answer: loadResult.answers[1].answer,
                  isCurrentAnswer: loadResult.answers[1].isCurrentAnswer,
                  percent: '${loadResult.answers[1].percent}%',
                )
              ],
            ),
          )));

      await sut.loadData();
    });

    test('Should throw correct errors on failure', () async {
      mockLoadSurveyResultError();
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description),
          ));

      await sut.loadData();
    });

    test('Should emit correct events on access denied', () async {
      mockLoadAccessDeniedError();
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });

  group('save', () {
    SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) {
      return SurveyResultViewModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers: [
          SurveyAnswerViewModel(
            image: entity.answers[0].image,
            answer: entity.answers[0].answer,
            isCurrentAnswer: entity.answers[0].isCurrentAnswer,
            percent: '${entity.answers[0].percent}%',
          ),
          SurveyAnswerViewModel(
            answer: entity.answers[1].answer,
            isCurrentAnswer: entity.answers[1].isCurrentAnswer,
            percent: '${entity.answers[1].percent}%',
          )
        ],
      );
    }

    test('Should call LoadSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(() => saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.surveyResultStream,
          emitsInOrder([
            mapToViewModel(loadResult),
            mapToViewModel(saveResult),
          ]));

      await sut.loadData();
      await sut.save(answer: answer);
    });

    test('Should throw correct errors on failure', () async {
      mockSaveSurveyResultError();
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description),
          ));

      await sut.save(answer: answer);
    });

    test('Should emit correct events on access denied', () async {
      mockSaveAccessDeniedError();
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });
  });
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mocktail/mocktail.dart';

import '../../../lib/ui/helpers/helpers.dart';
import '../../../lib/ui/pages/survey_result/components/components.dart';
import '../../../lib/ui/pages/pages.dart';
import '../../mocks/mocks.dart';

import '../helpers/helpers.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  late SurveyResultPresenterSpy presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<SurveyResultViewModel?> surveyResultController;
  late StreamController<bool> isSessionExpiredController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveyResultController = StreamController<SurveyResultViewModel?>();
    isSessionExpiredController = StreamController<bool>();
  }

  void closeStreams() {
    isLoadingController.close();
    surveyResultController.close();
    isSessionExpiredController.close();
  }

  void mockStreams() {
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.surveyResultStream)
        .thenAnswer((_) => surveyResultController.stream);
    when(() => presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    initStreams();
    mockStreams();

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(makePage(
        initialRoute: '/survey_result/any_survey_id',
        page: () => SurveyResultPage(presenter),
      ));
    });
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveyResult on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets("Should handle loading correctly", (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Should present error if surveyResultStream fails",
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text(R.translations.msgUnexpectedError), findsOneWidget);
    expect(find.text(R.translations.reloadButtonText), findsOneWidget);
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('Should call LoadSurveyResult on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.translations.reloadButtonText));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets("Should present valid data if surveyResultStream succeeds",
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(ViewModelFactory.makeSurveyResult());

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    expect(find.text(R.translations.msgUnexpectedError), findsNothing);
    expect(find.text(R.translations.reloadButtonText), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisabledIcon), findsOneWidget);

    final image =
        tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });

  testWidgets("Should logout", (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(currentRoute, '/login');

    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('Should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pump();
    expect(currentRoute, '/survey_result/any_survey_id');
  });

  testWidgets('Should call SaveSurveyResult on list item click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(ViewModelFactory.makeSurveyResult());

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });
    await tester.tap(find.text('Answer 1'));

    verify(() => presenter.save(answer: 'Answer 1')).called(1);
  });

  testWidgets('Should not call SaveSurveyResult on current answer click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(ViewModelFactory.makeSurveyResult());

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });
    await tester.tap(find.text('Answer 0'));

    verifyNever(() => presenter.save(answer: 'Answer 0'));
  });
}

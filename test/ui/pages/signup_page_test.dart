import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../../../lib/ui/pages/pages.dart';
import '../../../lib/ui/helpers/helpers.dart';
import '../helpers/helpers.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  late SignUpPresenter presenter;
  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;
  late StreamController<UIError?> mainErrorController;
  late StreamController<String?> navigateToController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  void initStreams() {
    nameErrorController = StreamController<UIError?>();
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    passwordConfirmationErrorController = StreamController<UIError?>();
    mainErrorController = StreamController<UIError?>();
    navigateToController = StreamController<String?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  void mockStreams() {
    when(() => presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();

    await tester.pumpWidget(makePage(
      initialRoute: '/signup',
      page: () => SignUpPage(presenter),
    ));
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets("Should call validate with correct values",
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(
        find.bySemanticsLabel(R.translations.nameLabel), name);
    verify(() => presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(
        find.bySemanticsLabel(R.translations.emailLabel), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(
        find.bySemanticsLabel(R.translations.passwordLabel), password);
    verify(() => presenter.validatePassword(password));

    await tester.enterText(
      find.bySemanticsLabel(R.translations.passwordConfirmationLabel),
      password,
    );
    verify(() => presenter.validatePasswordConfirmation(password));
  });

  testWidgets("Should present name error", (WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text(R.translations.msgInvalidField), findsOneWidget);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text(R.translations.msgRequiredField), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel(R.translations.nameLabel),
          matching: find.byType(Text)),
      findsOneWidget,
    );
  });
  testWidgets("Should present email error", (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text(R.translations.msgInvalidField), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text(R.translations.msgRequiredField), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel(R.translations.emailLabel),
          matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets("Should present password error", (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text(R.translations.msgInvalidField), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text(R.translations.msgRequiredField), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel(R.translations.passwordLabel),
          matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets("Should present passwordConfirmation error",
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text(R.translations.msgInvalidField), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text(R.translations.msgRequiredField), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel(R.translations.passwordConfirmationLabel),
          matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets("Should enable button if form is valid",
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNotNull);
  });

  testWidgets("Should disable button if form is invalid",
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);
  });

  testWidgets("Should call signUp on form submit", (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.signUp()).called(1);
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

  testWidgets("Should presents error message if signUp fails",
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.emailInUse);
    await tester.pump();

    expect(find.text(R.translations.msgEmailInUse), findsOneWidget);
  });

  testWidgets("Should presents error message if signUp throws",
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text(R.translations.msgUnexpectedError), findsOneWidget);
  });

  testWidgets("Should change page", (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');

    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(currentRoute, '/signup');

    navigateToController.add(null);
    await tester.pump();
    expect(currentRoute, '/signup');
  });

  testWidgets("Should call goToLogin on link click",
      (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text(R.translations.login);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToLogin()).called(1);
  });
}

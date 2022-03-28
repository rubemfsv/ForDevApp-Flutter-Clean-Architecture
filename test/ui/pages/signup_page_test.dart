import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../../../lib/ui/pages/pages.dart';
import '../../../lib/ui/helpers/helpers.dart';
import '../helpers/helpers.dart';
import '../../mocks/mocks.dart';

void main() {
  late SignUpPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    await tester.pumpWidget(makePage(
      initialRoute: '/signup',
      page: () => SignUpPage(presenter),
    ));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should call validate with correct values',
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
        password);
    verify(() => presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Should present email error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.translations.msgInvalidField), findsOneWidget);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.translations.msgRequiredField), findsOneWidget);

    presenter.emitEmailValid();
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel(R.translations.emailLabel),
            matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should present name error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNameError(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.translations.msgInvalidField), findsOneWidget);

    presenter.emitNameError(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.translations.msgRequiredField), findsOneWidget);

    presenter.emitNameValid();
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel(R.translations.nameLabel),
            matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should present password error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.translations.msgInvalidField), findsOneWidget);

    presenter.emitPasswordError(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.translations.msgRequiredField), findsOneWidget);

    presenter.emitPasswordValid();
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel(R.translations.passwordLabel),
          matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present passwordConfirmation error',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordConfirmationError(UIError.invalidField);
    await tester.pump();

    expect(find.text(R.translations.msgInvalidField), findsOneWidget);

    presenter.emitPasswordConfirmationError(UIError.requiredField);
    await tester.pump();

    expect(find.text(R.translations.msgRequiredField), findsOneWidget);

    presenter.emitPasswordConfirmationValid();
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel(R.translations.passwordConfirmationLabel),
            matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormError();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call signUp on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.signUp()).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading(true);
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(CircularProgressIndicator), findsNothing);

    presenter.emitLoading(true);
    await tester.pump(Duration(seconds: 5));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should present error message if signUp fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.emailInUse);
    await tester.pump();

    expect(find.text(R.translations.msgEmailInUse), findsOneWidget);
  });

  testWidgets('Should present error message if signUp throws',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.unexpected);
    await tester.pump();

    expect(find.text(R.translations.msgUnexpectedError), findsOneWidget);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();
    expect(currentRoute, '/signup');
  });

  testWidgets('Should call gotoLogin on link click',
      (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text(R.translations.login);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToLogin()).called(1);
  });
}

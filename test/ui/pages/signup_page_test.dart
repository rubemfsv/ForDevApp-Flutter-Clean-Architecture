import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/mockito.dart';

import 'package:hear_mobile/ui/pages/pages.dart';
import 'package:hear_mobile/ui/helpers/helpers.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;
  StreamController<UIError> nameErrorController;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;

  void initStreams() {
    nameErrorController = StreamController<UIError>();
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    passwordConfirmationErrorController = StreamController<UIError>();
    mainErrorController = StreamController<UIError>();
    navigateToController = StreamController<String>();
    isFormValidController = StreamController<bool>();
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
  }

  void mockStreams() {
    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: '/signUp',
      getPages: [
        GetPage(name: '/signUp', page: () => SignUpPage(presenter)),
        GetPage(
            name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets("Should load with correct initial state",
      (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.translations.nameLabel),
        matching: find.byType(Text));

    expect(
      nameTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no error, since one of the children is always the label text',
    );

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.translations.emailLabel),
        matching: find.byType(Text));

    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no error, since one of the children is always the label text',
    );

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.translations.passwordLabel),
        matching: find.byType(Text));

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no error, since one of the children is always the label text',
    );

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.translations.passwordConfirmationLabel),
        matching: find.byType(Text));

    expect(
      passwordConfirmationTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no error, since one of the children is always the label text',
    );

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets("Should call validate with correct values",
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(
        find.bySemanticsLabel(R.translations.nameLabel), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(
        find.bySemanticsLabel(R.translations.emailLabel), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(
        find.bySemanticsLabel(R.translations.passwordLabel), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(
      find.bySemanticsLabel(R.translations.passwordConfirmationLabel),
      password,
    );
    verify(presenter.validatePasswordConfirmation(password));
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

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

    expect(button.onPressed, isNotNull);
  });

  testWidgets("Should disable button if form is invalid",
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

    expect(button.onPressed, null);
  });
}

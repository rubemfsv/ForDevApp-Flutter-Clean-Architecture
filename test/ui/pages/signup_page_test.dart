import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/mockito.dart';

import 'package:hear_mobile/ui/pages/pages.dart';
import 'package:hear_mobile/ui/helpers/helpers.dart';


void main() {
 
  Future<void> loadPage(WidgetTester tester) async {

    final signUpPage = GetMaterialApp(
      initialRoute: '/signUp',
      getPages: [
        GetPage(name: '/signUp', page: () => SignUpPage()),
        GetPage(
            name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

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
}

import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/mockito.dart';

import 'package:enquetes/ui/pages/pages.dart';
import 'package:enquetes/ui/helpers/helpers.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> nameErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void initStreams() {
    emailErrorController = StreamController<UIError>();
    nameErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    passwordConfirmationErrorController = StreamController<UIError>();
    mainErrorController = StreamController<UIError>();
    navigateToController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    nameErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    mainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();
    final signUpPage = GetMaterialApp(
      initialRoute: "/signup",
      getPages: [
        GetPage(name: "/signup", page: () => SignUpPage(presenter)),
        GetPage(
            name: "/any_route", page: () => Scaffold(body: Text("fake page"))),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.email),
        matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.name), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.password),
        matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.passwordConfirmation),
        matching: find.byType(Text));
    expect(passwordConfirmationTextChildren, findsOneWidget);

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel(R.strings.email), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel(R.strings.password), password);
    verify(presenter.validatePassword(password));
  });

  testWidgets('Should validate email', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.msgInvalidField), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.msgRequiredField), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel(R.strings.email),
          matching: find.byType(Text)),
      findsOneWidget,
    );
  });
  testWidgets('Should validate name', (WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.msgInvalidField), findsOneWidget);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.msgRequiredField), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel(R.strings.name),
          matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should validate password', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.msgInvalidField), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.msgRequiredField), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel(R.strings.password),
            matching: find.byType(Text)),
        findsOneWidget);
  });
  testWidgets('Should validate passwordConfirmation',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.msgInvalidField), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.msgRequiredField), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel(R.strings.passwordConfirmation),
            matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should validate button enabled and disabled',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    var buttonNotNull = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(buttonNotNull.onPressed, isNotNull);

    isFormValidController.add(false);
    await tester.pump();
    var buttonNull = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(buttonNull.onPressed, null);
  });

  testWidgets('Should call signup on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();

    verify(presenter.signUp()).called(1);
  });

  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if signUp fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.emailInUse);
    await tester.pump();

    expect(find.text(R.strings.msgEmailInUse), findsOneWidget);
  });

  testWidgets('Should present error message if signUp throws',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text(R.strings.msgUnexpectedError), findsOneWidget);
  });
  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, "any_route");
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets("Should not change page", (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add("");
    await tester.pump();
    expect(Get.currentRoute, "/signup");

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, "/signup");
  });

  testWidgets("Should change to LoginPage", (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.bySemanticsLabel(R.strings.login);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToLoginPage()).called(1);
  });
}

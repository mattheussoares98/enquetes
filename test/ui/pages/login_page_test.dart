import "package:enquetes/ui/pages/pages.dart";
import "package:faker/faker.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter = LoginPresenterSpy();
  group("Test formFields", () {
    Future<void> loadPage(WidgetTester tester) async {
      final loginPage = MaterialApp(
          home: LoginPage(
        loginPresenter: presenter,
      ));
      await tester.pumpWidget(loginPage);
    }

    testWidgets(
      "Should load with correct initial state",
      (WidgetTester tester) async {
        await loadPage(tester);
        //precisa fazer isso acima pra indicar qual widget está testando. No
        //caso está testando o LoginPage

        //testando quando um widget possui como label "Email"
        //procurando o tipo Text
        final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel("Email"),
          matching: find.byType(Text),
        );

        //'Quando um TextFormField tem somente um filho do tipo TEXT
        //(labeltext e errorText são filhos do widget), significa que não
        //possui erros porque um dos filhos sempre vai ser o labelText',
        expect(
          emailTextChildren,
          findsOneWidget,
        );

        //testando quando um widget possui como label "Senha"
        //procurando o tipo Text
        final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel("Senha"),
          matching: find.byType(Text),
        );

        //'Quando um TextFormField tem somente um filho do tipo TEXT
        //(labeltext e errorText são filhos do widget), significa que não
        //possui erros porque um dos filhos sempre vai ser o labelText',
        expect(
          passwordTextChildren,
          findsOneWidget,
        );

        //procurando um widget do tipo ElevatedButton para testar o onPressed
        //dele
        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, null);
      },
    );

    testWidgets(
      "Should call with correct values",
      (WidgetTester tester) async {
        await loadPage(tester);

        final email = faker.internet.email();
        await tester.enterText(find.bySemanticsLabel("Email"), email);

        verify(() => presenter.validateEmail(email));

        final password = faker.internet.email();
        await tester.enterText(find.bySemanticsLabel("Senha"), password);

        verify(() => presenter.validatePassword(password));
      },
    );
  });
}

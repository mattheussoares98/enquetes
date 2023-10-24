import "dart:async";

import "package:enquetes/ui/pages/pages.dart";
import "package:faker/faker.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class LoginPresenterSpy extends Mock implements LoginPresenter {
  StreamController<String> emailErrorController =
      StreamController<String>.broadcast();

  @override
  Stream<String> get emailErrorStream => emailErrorController.stream;
}

void main() {
  late LoginPresenter presenter;
  late StreamController<String> emailErrorController;

  group("Test formFields", () {
    Future<void> loadPage(WidgetTester tester) async {
      presenter = LoginPresenterSpy();
      emailErrorController = StreamController<String>();

      final loginPage = MaterialApp(
          home: LoginPage(
        loginPresenter: presenter,
      ));
      await tester.pumpWidget(loginPage);
    }

    tearDown(() => emailErrorController.close());

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
        await tester.enterText(
            find.byKey(
              //usando outra forma para identificar o widget que quero testar.
              //Coloquei uma chave Key pra esse widget e aqui consultei por essa Key
              const Key("PasswordKeyForTests"),
            ),
            password);

        verify(() => presenter.validatePassword(password));
      },
    );

    testWidgets(
      "Should present error if email is invalid",
      (WidgetTester tester) async {
        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter.emailErrorStream
        await loadPage(tester);

        when(() => presenter.emailErrorStream)
            .thenAnswer((_) => emailErrorController.stream);
        //sempre que houver alteração no stream, vai ser atualizado o valor
        //nessa versão mocada

        emailErrorController.add("any error");
        //se o controller emitir qualquer texto, essa string vai do strem vai
        //ser emitida e "cair" no formfield, exibindo a mensagem na tela

        await tester.pump();
        //força uma renderização da página

        expect(find.text("any error"), findsOneWidget);
      },
    );
  });
}

import "dart:async";
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import "package:flutter/material.dart";

import "package:enquetes/ui/pages/pages.dart";
import "package:flutter_test/flutter_test.dart";

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();

    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

    //sempre que houver alteração no stream, vai ser atualizado o valor
    //nessa versão mocada

    final loginPage = MaterialApp(
        home: LoginPage(
      loginPresenter: presenter,
    ));
    await tester.pumpWidget(loginPage);
  }

  group("Test formFields", () {
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
          of: find.bySemanticsLabel('Email'),
          matching: find.byType(Text),
        );

        //'Quando um TextFormField tem somente um filho do tipo TEXT
        //(labeltext e errorText são filhos do widget), significa que não
        //possui erros porque um dos filhos sempre vai ser o labelText',
        expect(
          emailTextChildren,
          findsOneWidget,
        );

        //procurando um widget do tipo RaisedButton para testar o onPressed
        //dele
        final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
        expect(button.onPressed, null);
      },
    );

    testWidgets(
      "Should call with correct values",
      (WidgetTester tester) async {
        await loadPage(tester);

        final email = faker.internet.email();
        await tester.enterText(find.bySemanticsLabel("Email"), email);

        verify(presenter.validateEmail(email));

        final password = faker.internet.email();
        await tester.enterText(
            find.byKey(
              //usando outra forma para identificar o widget que quero testar.
              //Coloquei uma chave Key pra esse widget e aqui consultei por essa Key
              const Key("PasswordKeyForTests"),
            ),
            password);

        verify(presenter.validatePassword(password));
      },
    );

    testWidgets(
      "Should present error if email is invalid",
      (WidgetTester tester) async {
        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter.emailErrorStream
        await loadPage(tester);

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

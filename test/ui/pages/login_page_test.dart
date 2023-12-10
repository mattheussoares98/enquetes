import "dart:async";
import 'package:faker/faker.dart';
import "package:flutter/material.dart";

import "package:enquetes/ui/pages/pages.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter? presenter;
  StreamController<String?>? emailErrorController;
  StreamController<String?>? passwordErrorController;
  StreamController<bool?>? isFormValidController;
  StreamController<bool?>? isLoadingController;
  StreamController<String?>? mainErrorController;

  void initStreams() {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<String>();
  }

  void mockStreams() {
    when(() => presenter!.emailErrorStream)
        .thenAnswer((_) => emailErrorController!.stream);
    when(() => presenter!.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController!.stream);
    when(() => presenter!.isFormValidStream)
        .thenAnswer((_) => isFormValidController!.stream);
    when(() => presenter!.isLoadingStream)
        .thenAnswer((_) => isLoadingController!.stream);
    when(() => presenter!.mainErrorStream)
        .thenAnswer((_) => mainErrorController!.stream);
  }

  void closeStreams() {
    emailErrorController!.close();
    passwordErrorController!.close();
    isFormValidController!.close();
    isLoadingController!.close();
    mainErrorController!.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();

    final loginPage = MaterialApp(
        home: LoginPage(
      presenter!,
    ));
    await tester.pumpWidget(loginPage);
  }

  group("Test formFields", () {
    tearDown(
      () {
        closeStreams();
      },
    );

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

        //procurando um widget do tipo ElevatedButton para testar o onPressed
        //dele
        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, null);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets(
      "Should call with correct values",
      (WidgetTester tester) async {
        await loadPage(tester);

        final email = faker.internet.email();
        await tester.enterText(find.bySemanticsLabel("Email"), email);

        verify(() => presenter!.validateEmail(email));

        final password = faker.internet.email();
        await tester.enterText(
            find.byKey(
              //usando outra forma para identificar o widget que quero testar.
              //Coloquei uma chave Key pra esse widget e aqui consultei por essa Key
              const Key("PasswordKeyForTests"),
            ),
            password);

        verify(() => presenter!.validatePassword(password));
      },
    );

    testWidgets(
      "Should present error if email is invalid",
      (WidgetTester tester) async {
        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter!.emailErrorStream
        await loadPage(tester);

        emailErrorController!.add("any error");
        //se o controller emitir qualquer texto, essa string vai do strem vai
        //ser emitida e "cair" no formfield, exibindo a mensagem na tela

        await tester.pump();
        //força uma renderização da página

        expect(find.text("any error"), findsOneWidget);
      },
    );

    testWidgets(
      "Should present no error if email is valid",
      (WidgetTester tester) async {
        await loadPage(tester);

        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter!.emailErrorStream
        when(() => presenter!.emailErrorStream)
            .thenAnswer((_) => emailErrorController!.stream);

        emailErrorController!.add("");
        //se o controller emitir qualquer texto, essa string vai do strem vai
        //ser emitida e "cair" no formfield, exibindo a mensagem na tela

        await tester.pump();
        //força uma renderização da página

        expect(
          find.descendant(
            of: find.bySemanticsLabel('Email'),
            matching: find.byType(Text),
          ),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      "Should present no error if email is valid",
      (WidgetTester tester) async {
        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter!.emailErrorStream
        await loadPage(tester);

        emailErrorController!.add("");
        //se o controller emitir qualquer texto, essa string vai do strem vai
        //ser emitida e "cair" no formfield, exibindo a mensagem na tela

        await tester.pump();
        //força uma renderização da página

        expect(
          find.descendant(
            of: find.bySemanticsLabel('Email'),
            matching: find.byType(Text),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "Should present error if password is invalid",
      (WidgetTester tester) async {
        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter!.emailErrorStream
        await loadPage(tester);

        passwordErrorController!.add("any error");
        //se o controller emitir qualquer texto, essa string vai do strem vai
        //ser emitida e "cair" no formfield, exibindo a mensagem na tela

        await tester.pump();
        //força uma renderização da página

        expect(find.text("any error"), findsOneWidget);
      },
    );

    testWidgets(
      "Should present no error if password is valid",
      (WidgetTester tester) async {
        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter!.passwordErrorStream
        await loadPage(tester);

        when(() => presenter!.passwordErrorStream)
            .thenAnswer((_) => passwordErrorController!.stream);

        passwordErrorController!.add("");
        //se o controller emitir qualquer texto, essa string vai do strem vai
        //ser emitida e "cair" no formfield, exibindo a mensagem na tela

        await tester.pump();
        //força uma renderização da página

        expect(
          find.descendant(
            of: find.bySemanticsLabel('Senha'),
            matching: find.byType(Text),
          ),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      "Should present no error if password is valid",
      (WidgetTester tester) async {
        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter!.passwordErrorStream
        await loadPage(tester);

        passwordErrorController!.add("");
        //se o controller emitir qualquer texto, essa string vai do strem vai
        //ser emitida e "cair" no formfield, exibindo a mensagem na tela

        await tester.pump();
        //força uma renderização da página

        expect(
          find.descendant(
            of: find.bySemanticsLabel('Senha'),
            matching: find.byType(Text),
          ),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      "Should enable button if form is valid",
      (WidgetTester tester) async {
        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter!.passwordErrorStream
        await loadPage(tester);

        isFormValidController!.add(true);
        //se o controller emitir qualquer texto, essa string vai do strem vai
        //ser emitida e "cair" no formfield, exibindo a mensagem na tela

        await tester.pump();
        //força uma renderização da página

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNotNull);
      },
    );
    testWidgets(
      "Should disable button if form is invalid",
      (WidgetTester tester) async {
        //PRA FUNCIONAR ESSE TESTE ABAIXO, PRECISOU ENVOLVER O TEXTFORMFIELD COM
        //UMA STREAM DO TIPO presenter!.passwordErrorStream
        await loadPage(tester);

        isFormValidController!.add(false);
        //se o controller emitir qualquer texto, essa string vai do strem vai
        //ser emitida e "cair" no formfield, exibindo a mensagem na tela

        await tester.pump();
        //força uma renderização da página

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, null);
      },
    );

    testWidgets(
      "Should present loading",
      (WidgetTester tester) async {
        await loadPage(tester);

        isLoadingController!.add(true);

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );
    testWidgets(
      "Should hide loading",
      (WidgetTester tester) async {
        await loadPage(tester);

        isLoadingController!.add(true);
        await tester.pump();
        isLoadingController!.add(false);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );
    testWidgets(
      "Should present error message if authentication fails",
      (WidgetTester tester) async {
        await loadPage(tester);

        mainErrorController!.add("Erro para efetuar o login");
        await tester.pump();

        expect(find.text("Erro para efetuar o login"), findsOneWidget);
      },
    );
    testWidgets(
      "Should close streams on dispose",
      (WidgetTester tester) async {
        await loadPage(tester);

        addTearDown(() {
          //chama quando o widget que está sendo usado no teste é encerrado.
          //Então aqui é ctz que o LoginPage está sendo encerrado
          verify(() => presenter!.dispose()).called(1);
        });
      },
    );
  });
}

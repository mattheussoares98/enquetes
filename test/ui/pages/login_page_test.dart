import "package:enquetes/ui/pages/login_page.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("Test formFields", () {
    testWidgets(
      "Should load with correct initial state",
      (WidgetTester tester) async {
        const loginPage = MaterialApp(home: LoginPage());
        await tester.pumpWidget(loginPage);
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
  });
}

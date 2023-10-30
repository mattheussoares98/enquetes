import 'package:flutter/material.dart';

import '../pages.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter loginPresenter;
  const LoginPage({
    @required this.loginPresenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        loginPresenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              child: SimpleDialog(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Aguarde...", textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),
            );
          }
        });

        return SingleChildScrollView(
          child: Column(
            children: [
              const LoginHeader(),
              const SizedBox(height: 30),
              const HeadLine1(text: "Login"),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: loginPresenter.emailErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email",
                                icon: const Icon(Icons.email),
                                errorText: snapshot.data?.isEmpty == true
                                    ? null
                                    : snapshot.data,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: loginPresenter.validateEmail,
                            );
                          }),
                      const SizedBox(height: 10),
                      StreamBuilder<String>(
                          stream: loginPresenter.passwordErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              key: const Key('PasswordKeyForTests'),
                              decoration: InputDecoration(
                                labelText: "Senha",
                                icon: Icon(Icons.lock),
                                errorText: snapshot.data?.isEmpty == true
                                    ? null
                                    : snapshot.data,
                              ),
                              obscureText: true,
                              onChanged: loginPresenter.validatePassword,
                            );
                          }),
                      const SizedBox(height: 30),
                      StreamBuilder<bool>(
                          stream: loginPresenter.isFormValidStream,
                          builder: (context, snapshot) {
                            return RaisedButton(
                              onPressed: snapshot.data == true
                                  ? loginPresenter.auth
                                  : null,
                              child: Text("Entrar".toUpperCase()),
                            );
                          }),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

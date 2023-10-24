import 'package:flutter/material.dart';

import '../pages.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter loginPresenter;
  const LoginPage({
    required this.loginPresenter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                              errorText: snapshot.data,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: loginPresenter.validateEmail,
                          );
                        }),
                    const SizedBox(height: 10),
                    TextFormField(
                      key: const Key('PasswordKeyForTests'),
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      onChanged: loginPresenter.validatePassword,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: null,
                      child: Text("Entrar".toUpperCase()),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text("Criar conta"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

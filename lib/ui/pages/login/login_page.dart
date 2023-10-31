import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';
import '../../components/components.dart';
import 'components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter loginPresenter;
  const LoginPage({
    @required this.loginPresenter,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.loginPresenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.loginPresenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        widget.loginPresenter.mainErrorStream.listen((error) {
          if (error != null) {
            showErrorMessage(context: context, error: error);
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
                child: Provider(
                  create: (_) => widget.loginPresenter,
                  child: Form(
                    child: Column(
                      children: [
                        EmailInput(),
                        const SizedBox(height: 10),
                        StreamBuilder<String>(
                            stream: widget.loginPresenter.passwordErrorStream,
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
                                onChanged:
                                    widget.loginPresenter.validatePassword,
                              );
                            }),
                        const SizedBox(height: 30),
                        StreamBuilder<bool>(
                            stream: widget.loginPresenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return RaisedButton(
                                onPressed: snapshot.data == true
                                    ? widget.loginPresenter.auth
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
              ),
            ],
          ),
        );
      }),
    );
  }
}

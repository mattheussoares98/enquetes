import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    LoginPresenter loginPresenter = Provider.of(context);
    return StreamBuilder<String?>(
        stream: loginPresenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            key: const Key('PasswordKeyForTests'),
            decoration: InputDecoration(
              labelText: "Senha",
              icon: const Icon(Icons.lock),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
            obscureText: true,
            onChanged: loginPresenter.validatePassword,
          );
        });
  }
}

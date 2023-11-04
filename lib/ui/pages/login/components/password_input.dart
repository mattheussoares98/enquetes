import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginPresenter loginPresenter = Provider.of(context);
    return StreamBuilder<String>(
        stream: loginPresenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            key: const Key('PasswordKeyForTests'),
            decoration: InputDecoration(
              labelText: "Senha",
              icon: Icon(Icons.lock),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
            obscureText: true,
            onChanged: loginPresenter.validatePassword,
          );
        });
  }
}

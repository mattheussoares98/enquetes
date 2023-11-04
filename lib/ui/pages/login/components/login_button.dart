import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginPresenter loginPresenter = Provider.of(context);

    return StreamBuilder<bool>(
        stream: loginPresenter.isFormValidStream,
        builder: (context, snapshot) {
          return RaisedButton(
            onPressed: snapshot.data == true ? loginPresenter.auth : null,
            child: Text("Entrar".toUpperCase()),
          );
        });
  }
}

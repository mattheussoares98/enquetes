import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../signup_presenter.dart';
import '../../../helpers/helpers.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return FlatButton.icon(
            onPressed: snapshot.data == true ? presenter.signUp : null,
            icon: Icon(Icons.person),
            label: Text(R.strings.signUp.toUpperCase()));
      },
    );
  }
}

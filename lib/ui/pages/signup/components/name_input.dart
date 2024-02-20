import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../signup_presenter.dart';
import '../../../helpers/helpers.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.name,
            icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
            errorText: snapshot.hasData ? snapshot.data.description : null,
          ),
          keyboardType: TextInputType.name,
          onChanged: presenter.validateEmail,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    LoginPresenter presenter = Provider.of(context);
    return StreamBuilder(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: "Email",
              icon: const Icon(Icons.email),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: presenter.validateEmail,
          );
        });
  }
}

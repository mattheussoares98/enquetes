import 'dart:async';
import 'package:meta/meta.dart';

import '../protocols/validation.dart';

class LoginState {
  String emailError;
  String email;
  String passwordError;
  String password;
  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      password != null &&
      email != null;
}

class StreamLoginPresenter {
  final Validation validation;
  StreamLoginPresenter({@required this.validation});

  final _controller = StreamController<LoginState>.broadcast();
  var _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream
      .map((state) => state.emailError)
      //só vai emitir um novo valor se for diferente do valor anterior
      .distinct();

  Stream<String> get passwordErrorStream => _controller.stream
      .map((state) => state.passwordError)
      //só vai emitir um novo valor se for diferente do valor anterior
      .distinct();

  Stream<bool> get isFormValidStream => _controller.stream
      .map((state) => state.isFormValid)
      //só vai emitir um novo valor se for diferente do valor anterior
      .distinct();

  void _update() => _controller.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: "email", value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: "password", value: password);
    _update();
  }
}

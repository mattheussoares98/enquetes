import 'dart:async';
import 'package:meta/meta.dart';

import '../protocols/validation.dart';

class LoginState {
  String emailError;
  String passwordError;
  bool get isFormValid => false;
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

  Stream<bool> get isFormValidStream => _controller.stream
      .map((state) => state.isFormValid)
      //só vai emitir um novo valor se for diferente do valor anterior
      .distinct();

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: "email", value: email);
    _controller.add(_state);
  }

  void validatePassword(String password) {
    validation.validate(field: "password", value: password);
  }
}

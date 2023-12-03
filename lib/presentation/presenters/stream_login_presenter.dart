import 'dart:async';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../protocols/validation.dart';

class LoginState {
  String emailError;
  String email;
  String passwordError;
  String password;
  String mainError;
  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      password != null &&
      email != null;
  bool isLoading = false;
}

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;
  StreamLoginPresenter({
    @required this.validation,
    @required this.authentication,
  });

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

  Stream<bool> get isLoadingStream => _controller.stream
      .map((state) => state.isLoading)
      //só vai emitir um novo valor se for diferente do valor anterior
      .distinct();

  Stream<String> get mainErrorStream => _controller.stream
      .map((state) => state.mainError)
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

  Future<void> auth() async {
    _state.isLoading = true;
    _update();

    try {
      await authentication.auth(
        AuthenticationParams(
          email: _state.email,
          password: _state.password,
        ),
      );
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }

    _state.isLoading = false;
    _update();
  }
}

import 'dart:async';

import 'package:meta/meta.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class LoginState {
  UIError mainError;
  UIError emailError;
  UIError passwordError;
  String email;
  String password;
  bool isLoading = false;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  var _controller = StreamController<LoginState>.broadcast();
  var _state = LoginState();

  Stream<UIError> get emailErrorStream =>
      _controller?.stream?.map((state) => state.emailError)?.distinct();
  Stream<UIError> get passwordErrorStream =>
      _controller?.stream?.map((state) => state.passwordError)?.distinct();
  Stream<UIError> get mainErrorStream =>
      _controller?.stream?.map((state) => state.mainError)?.distinct();
  Stream<bool> get isFormValidStream =>
      _controller?.stream?.map((state) => state.isFormValid)?.distinct();
  Stream<bool> get isLoadingStream =>
      _controller?.stream?.map((state) => state.isLoading)?.distinct();

  StreamLoginPresenter(
      {@required this.validation, @required this.authentication});

  void _update() => _controller?.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = _validateField('email');
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = _validateField('password');
    _update();
  }

  UIError _validateField(String field) {
    Map formData = {
      "email": _state.email,
      "password": _state.password,
    };
    ValidationError validationError = validation.validate(
      field: field,
      input: formData,
    );

    switch (validationError) {
      case ValidationError.invalidField:
        return UIError.invalidField;
        break;
      case ValidationError.requiredField:
        return UIError.requiredField;
        break;
      default:
        return null;
    }
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    try {
      await authentication.auth(
          AuthenticationParams(email: _state.email, secret: _state.password));
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _state.mainError = UIError.invalidCredentials;
          break;
        case DomainError.unexpected:
          _state.mainError = UIError.unexpected;
          break;

        default:
          _state.mainError = null;
      }
    }
    _state.isLoading = false;
    _update();
  }

  void dispose() {
    _controller?.close();
    _controller = null;
  }

  @override
  Stream<String> get navigateToStream => throw UnimplementedError();

  @override
  void goToSignUpPage() {}
}

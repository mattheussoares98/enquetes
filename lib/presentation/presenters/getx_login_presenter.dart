import 'package:get/get.dart';
import 'dart:async';

import '../protocols/validation.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  String? _email;
  String? _password;
  final Rxn<String?> _emailError = Rxn<String>();
  final Rxn<String?> _mainError = Rxn<String>();
  final Rxn<String?> _passwordError = Rxn<String>();
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  @override
  Stream<String?>? get emailErrorStream => _emailError.stream;
  @override
  Stream<String?>? get passwordErrorStream => _passwordError.stream;
  @override
  Stream<bool?>? get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool?>? get isLoadingStream => _isLoading.stream;
  @override
  Stream<String?>? get mainErrorStream => _mainError.stream;

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _password != null &&
        _email != null;
  }

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: "email", value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: "password", value: password);
    _validateForm();
  }

  @override
  Future<void> auth() async {
    _isLoading.value = true;
    _validateForm();

    try {
      await authentication.auth(
        AuthenticationParams(
          email: _email!,
          password: _password!,
        ),
      );
    } on DomainError catch (error) {
      _mainError.value = error.description;
    }

    _isLoading.value = false;
    _validateForm();
  }
}

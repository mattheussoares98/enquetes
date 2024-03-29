import 'package:enquetes/domain/entities/account_entity.dart';
import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  String _name;
  String _passwordConfirmation;
  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _passwordConfirmationError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _navigateTo = Rx<String>();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
    _validateForm();
  }

  @override
  void goToLoginPage() {
    _navigateTo.value = "/login";
  }

  UIError _validateField(String field) {
    Map formData = {
      "email": _email,
      "password": _password,
      "name": _name,
      "passwordConfirmation": _passwordConfirmation,
    };

    ValidationError validationError = validation.validate(
      field: field,
      input: formData,
    );

    switch (validationError) {
      case ValidationError.invalidField:
        return UIError.invalidField;

      case ValidationError.requiredField:
        return UIError.requiredField;
        break;

      default:
        return null;
    }
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _nameError.value == null &&
        _passwordConfirmationError.value == null &&
        _email != null &&
        _password != null &&
        _name != null &&
        _passwordConfirmation != null;
  }

  Future<void> signUp() async {
    _mainError.value = null;
    try {
      _isLoading.value = true;
      AccountEntity account = await addAccount.add(
        AddAccountParams(
          email: _email,
          name: _name,
          password: _password,
          passwordConfirmation: _passwordConfirmation,
        ),
      );

      await saveCurrentAccount.save(account);
      _navigateTo.value = "/surveys";
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;
        default:
          _mainError.value = UIError.unexpected;
      }

      _isLoading.value = false;
    }
  }
}

import '../../helpers/helpers.dart';

abstract class SignUpPresenter {
  Stream<UIError> get emailErrorStream;
  Stream<UIError> get nameErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get passwordConfirmationErrorStream;
  Stream<UIError> get mainErrorStream;
  Stream<String> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> signUp();
}

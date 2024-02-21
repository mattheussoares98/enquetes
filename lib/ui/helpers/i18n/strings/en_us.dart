import 'translations.dart';

class EnUs implements Translations {
  String get msgRequiredField => "Required field";
  String get msgEmailInUse => "The e-mail already in use";
  String get msgInvalidField => "Invalid field";
  String get msgInvalidCredentials => "Invalid credentials";
  String get msgUnexpectedError => "Unexpected error";

  String get addAccount => "Add account";
  String get email => "Email";
  String get name => "Name";
  String get login => "Login";
  String get password => "Password";
  String get passwordConfirmation => "Confirm password";
  String get signUp => "Sign up";
}

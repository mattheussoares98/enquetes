import 'translations.dart';

class PtBr implements Translations {
  String get msgRequiredField => 'Campo obrigatório';
  String get msgEmailInUse => 'O e-mail já está em uso';
  String get msgInvalidField => 'Campo inválido';
  String get msgInvalidCredentials => 'Credenciais inválidas.';
  String get msgUnexpectedError =>
      'Algo errado aconteceu. Tente novamente em breve.';

  String get addAccount => "Criar conta";
  String get email => "Email";
  String get login => "Entrar";
  String get name => "Nome";
  String get password => "Senha";
  String get passwordConfirmation => "Confirmar senha";
  String get signUp => "Cadastrar";
}

import '../entities/account_entity.dart';
import 'package:meta/meta.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String password;
  final Map body;

  AuthenticationParams({
    @required this.email,
    @required this.password,
    this.body,
  });
}

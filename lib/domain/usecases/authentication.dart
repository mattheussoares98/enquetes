import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String password;
  final Map body;

  List get props => [email, password];
  //usou o Equatable e o props para conseguir comparar objetos no teste de authentication. Sem isso, não daria certo

  AuthenticationParams({
    @required this.email,
    @required this.password,
    this.body,
  });
}

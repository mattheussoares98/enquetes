import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}

class AddAccountParams extends Equatable {
  final String email;
  final String name;
  final String password;
  final String passwordConfirmation;

  @override
  List get props => [email, password, passwordConfirmation, name];

  AddAccountParams({
    @required this.email,
    @required this.name,
    @required this.password,
    @required this.passwordConfirmation,
  });
}

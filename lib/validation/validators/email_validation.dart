import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const EmailValidation(this.field);

  @override
  String? validate(String? value) {
    final RegExp regex =
        RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

    bool isValid = value?.isNotEmpty != true || regex.hasMatch(value!);

    return isValid ? null : "Campo inválido";
  }

  @override
  List<Object?> get props => [field];
}

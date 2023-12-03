import 'package:enquetes/validation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String value) {
    final RegExp regex =
        RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

    bool isValid = value?.isNotEmpty != true || regex.hasMatch(value);

    return isValid ? null : "Campo inválido";
  }
}

main() {
  EmailValidation sut;
  setUp(() {
    sut = EmailValidation("any_field");
  });
  test("Should return null if email is empty", () {
    expect(sut.validate(""), null);
  });

  test("Should return null if email is null", () {
    expect(sut.validate(null), null);
  });

  test("Should return null if email is valid", () {
    expect(sut.validate("mattheussbarbosa@hotmail.com"), null);
  });

  test("Should return null if email is invalid", () {
    expect(sut.validate("mattheussbarbosa"), "Campo inválido");
  });
}

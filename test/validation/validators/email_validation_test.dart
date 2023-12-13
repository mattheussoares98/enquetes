import 'package:flutter_test/flutter_test.dart';

import 'package:enquetes/validation/validators/validators.dart';

main() {
  EmailValidation? sut;
  setUp(() {
    sut = const EmailValidation("any_field");
  });
  test("Should return null if email is empty", () {
    expect(sut!.validate(""), null);
  });

  test("Should return null if email is null", () {
    expect(sut!.validate(null), null);
  });

  test("Should return null if email is valid", () {
    expect(sut!.validate("mattheussbarbosa@hotmail.com"), null);
  });

  test("Should return null if email is invalid", () {
    expect(sut!.validate("mattheussbarbosa"), "Campo inválido");
  });
}

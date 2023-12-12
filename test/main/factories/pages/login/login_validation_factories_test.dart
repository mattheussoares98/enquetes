import 'package:enquetes/main/factories/factories.dart';
import 'package:enquetes/validation/protocols/protocols.dart';
import 'package:enquetes/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the correct validations', () {
    List<FieldValidation> validations = makeLoginValidations();

    expect([
      const RequiredFieldValidation("email"),
      const EmailValidation("email"),
      const RequiredFieldValidation("password"),
    ], validations);
  });
}

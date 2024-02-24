import 'package:flutter_test/flutter_test.dart';

import 'package:enquetes/presentation/protocols/validation.dart';
import 'package:enquetes/validation/validators/validators.dart';

main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      valueToCompare: "any_value",
      field: "any_field",
    );
  });
  test("Should return error if value is empty", () {
    expect(sut.validate(""), ValidationError.invalidField);
  });

  test("Should return error if value is null", () {
    expect(sut.validate(null), ValidationError.invalidField);
  });

  test("Should return error if field is not equal to fieldToCompare", () {
    expect(
      sut.validate("wrong_value"),
      ValidationError.invalidField,
    );
  });
  test("Should return null if field is equal to fieldToCompare", () {
    expect(
      sut.validate("any_value"),
      null,
    );
  });
}

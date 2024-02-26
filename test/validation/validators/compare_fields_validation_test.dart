import 'package:flutter_test/flutter_test.dart';

import 'package:enquetes/presentation/protocols/validation.dart';
import 'package:enquetes/validation/validators/validators.dart';

main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: "any_field",
      fieldToCompare: "other_field",
    );
  });
  test("Should return error if value is empty", () {
    expect(sut.validate({"any_field": ""}), ValidationError.invalidField);
  });

  test("Should return error if value is null", () {
    expect(sut.validate({"any_field": "any_value", "other_field": null}), ValidationError.invalidField);
  });

  test("Should return error if field is not equal to fieldToCompare", () {
    expect(
      sut.validate({
        "any_field": "any_value",
        "other_field": "other_value",
      }),
      ValidationError.invalidField,
    );
  });
  test("Should return null if field is equal to fieldToCompare", () {
    expect(
      sut.validate({
        "any_field": "any_value",
        "other_field": "any_value",
      }),
      null,
    );
  });
}

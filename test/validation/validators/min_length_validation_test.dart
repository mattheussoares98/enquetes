import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

import 'package:enquetes/presentation/protocols/validation.dart';

import 'package:enquetes/validation/validators/validators.dart';

main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(
      field: anyNamed("field"),
      length: 5,
    );
  });
  test("Should return error if value is empty", () {
    expect(sut.validate(""), ValidationError.invalidField);
  });

  test("Should return error if value is null", () {
    expect(sut.validate(null), ValidationError.invalidField);
  });

  test("Should return error if value is less than min size", () {
    expect(
      sut.validate(
        faker.randomGenerator.string(4, min: 1),
      ),
      ValidationError.invalidField,
    );
  });
  test("Should return null if value is greather than min size", () {
    expect(
      sut.validate(
        faker.randomGenerator.string(14, min: 6),
      ),
      null,
    );
  });

  test("Should return null if value is equal min size", () {
    expect(
      sut.validate(
        faker.randomGenerator.string(5, min: 5),
      ),
      null,
    );
  });
}

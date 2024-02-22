import 'package:enquetes/presentation/protocols/validation.dart';
import 'package:enquetes/validation/protocols/protocols.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MinLengthValidation implements FieldValidation {
  final String fieldToValidate;
  final int length;
  MinLengthValidation({
    @required this.fieldToValidate,
    @required this.length,
  });

  @override
  String get field => throw UnimplementedError();

  @override
  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }
}

main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(
      fieldToValidate: anyNamed("field"),
      length: 5,
    );
  });
  test("Should return error if value is empty", () {
    expect(sut.validate(""), ValidationError.invalidField);
  });

  test("Should return error if value is null", () {
    expect(sut.validate(null), ValidationError.invalidField);
  });
}

import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:enquetes/validation/protocols/field_validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String validate({
    @required String field,
    @required String value,
  }) {
    return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

main() {
  ValidationComposite sut;
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;

  setUp(() {
    sut = ValidationComposite([validation1, validation2]);
  });
  test(
    "Should return null if all validations return null or empty",
    () {
      validation1 = FieldValidationSpy();
      when(validation1.field).thenReturn("any_field");
      when(validation1.validate(any)).thenReturn(null);
      validation2 = FieldValidationSpy();
      when(validation2.field).thenReturn("any_field");
      when(validation2.validate(any)).thenReturn("");

      final error = sut.validate(field: "any_field", value: "any_value");

      expect(error, null);
    },
  );
}

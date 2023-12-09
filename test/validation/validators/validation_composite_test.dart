import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:enquetes/validation/protocols/protocols.dart';
import 'package:enquetes/validation/validators/validators.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

main() {
  ValidationComposite? sut;
  FieldValidationSpy? validation1;
  FieldValidationSpy? validation2;

  void mockValidation1(String? error) {
    when(() => validation1!.validate(any()))
        .thenReturn(error == "" ? null : error);
  }

  void mockValidation2(String? error) {
    when(() => validation2!.validate(any()))
        .thenReturn(error == "" ? null : error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(() => validation1!.field).thenReturn("first_field");
    mockValidation1(null);

    validation2 = FieldValidationSpy();
    when(() => validation2!.field).thenReturn("second_field");
    mockValidation2(null);
    sut = ValidationComposite([validation1!, validation2!]);
  });
  test(
    "Should return null if all validations return null or empty",
    () {
      mockValidation2("");
      final error = sut!.validate(field: "second_field", value: "any_value");

      expect(error, null);
    },
  );
  test(
    "Should return the first error",
    () {
      mockValidation1("error1");
      mockValidation2("error2");

      final error = sut!.validate(field: "second_field", value: "any_value");

      expect(error, "error2");
    },
  );
}

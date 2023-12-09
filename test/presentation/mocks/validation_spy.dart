import 'package:mocktail/mocktail.dart';

import 'package:enquetes/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {
  ValidationSpy() {
    mockValidation();
  }

  When mockValidationCall(String? field) => when(() => validate(
        value: any(named: "value"),
        field: field ?? any(named: 'field'),
      ));

  void mockValidation({String? field}) =>
      mockValidationCall(field).thenReturn(null);

  void mockValidationError({String? field, required String value}) =>
      mockValidationCall(field).thenReturn(value);
}

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

abstract class Validation {
  String validate({
    @required String field,
    @required String value,
  }) {}
}

class ValidationSpy extends Mock implements Validation {}

class StreamLoginPresenter {
  final Validation validation;
  StreamLoginPresenter({@required this.validation});

  void validateEmail(String email) {
    validation.validate(field: "email", value: email);
  }
}

void main() {
  StreamLoginPresenter sut;
  ValidationSpy validation;
  String email;

  setUp(() {
    sut = StreamLoginPresenter(validation: validation);
    validation = ValidationSpy();
    email = faker.internet.email();
  });

  test(
    "Should call Validation with correct email",
    () {
      sut.validateEmail(email);

      verify(
        validation.validate(field: "email", value: email),
      ).called(1);
    },
  );
}

import '../../validation/protocols/protocols.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static ValidationBuilder _instance;
  String fieldName;
  List<FieldValidation> validations = [];

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder();
    _instance.fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(fieldName));
    return this;
  }

  ValidationBuilder minLenght(int value) {
    validations.add(MinLengthValidation(field: fieldName, length: 3));
    return this;
  }

  ValidationBuilder sameAs(String value) {
    validations.add(
      CompareFieldsValidation(
        fieldToCompare: value,
        field: fieldName,
      ),
    );
    return this;
  }

  List<FieldValidation> build() => validations;
}

import '../../validation/protocols/protocols.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static late ValidationBuilder _instance;
  late String _fieldName;
  final List<FieldValidation> _validations = [];

  ValidationBuilder._();

  static ValidationBuilder field(String fieldName) {
    //sempre vão precisar usar esse método primeiro pra conseguir utilizar os
    //outros
    _instance = ValidationBuilder._();
    _instance._fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    _validations.add(RequiredFieldValidation(_fieldName));
    return this;
  }

  ValidationBuilder email() {
    _validations.add(EmailValidation(_fieldName));
    return this;
  }

  List<FieldValidation> build() => _validations;
}

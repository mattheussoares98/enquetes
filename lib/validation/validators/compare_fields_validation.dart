import '../../presentation/protocols/protocols.dart';
import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String valueToCompare;
  final String field;

  CompareFieldsValidation({
    @required this.valueToCompare,
    @required this.field,
  });

  @override
  ValidationError validate(String value) {
    return value == valueToCompare ? null : ValidationError.invalidField;
  }
}

import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

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
    return value != null && value.length >= length
        ? null
        : ValidationError.invalidField;
  }
}

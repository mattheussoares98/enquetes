import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String fieldToCompare;
  final String field;

  CompareFieldsValidation({
    @required this.fieldToCompare,
    @required this.field,
  });

  List get props => [fieldToCompare, field];

  @override
  ValidationError validate(Map input) {
    return input[field] != null &&
            input[fieldToCompare] != null &&
            input[field] != input[fieldToCompare]
        ? ValidationError.invalidField
        : null;
  }
}

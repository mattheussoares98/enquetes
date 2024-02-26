import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../builders/builders.dart';

Validation makeSignUpValidation() {
  return ValidationComposite(makeSignUpValidations());
}

List<FieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().build(),
    ...ValidationBuilder.field("passwordConfirmation")
        .required()
        .sameAs("password")
        .build(),
  ];
}

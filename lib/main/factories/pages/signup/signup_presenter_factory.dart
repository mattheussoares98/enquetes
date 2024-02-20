import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SignUpPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeSignUpValidation(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}

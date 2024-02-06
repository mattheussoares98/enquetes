import 'package:enquetes/main/factories/usecases/load_current_account_factory.dart';

import '../../../../presentation/presenters/presenters.dart';

GetxSplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(
    loadCurrentAccount: makeLocalLoadCurrentAccount(),
  );
}

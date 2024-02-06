import 'package:enquetes/data/usecases/load_current_account/load_current_account.dart';
import 'package:enquetes/main/factories/cache/local_storage_adapter_factory.dart';

LocalLoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
  );
}

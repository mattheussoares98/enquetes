import 'package:enquetes/main/factories/cache/local_storage_adapter_factory.dart';

import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
    saveSecureCacheStorage: makeLocalStorageAdapter(),
  );
}

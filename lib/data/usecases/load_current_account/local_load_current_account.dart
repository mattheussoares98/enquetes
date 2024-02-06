import 'package:enquetes/domain/usecases/load_current_account.dart';
import 'package:meta/meta.dart';

import '../../../data/cache/cache.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/account_entity.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    try {
      await Future.delayed(Duration(seconds: 2));
      final token = await fetchSecureCacheStorage.fetchSecure("token");
      return AccountEntity(token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

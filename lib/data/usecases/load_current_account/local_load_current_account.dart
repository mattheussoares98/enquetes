import 'package:meta/meta.dart';

import '../../../data/cache/cache.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/account_entity.dart';

class LocalLoadCurrentAccount {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure("token");
      return AccountEntity(token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

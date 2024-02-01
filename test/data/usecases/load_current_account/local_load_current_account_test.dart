import 'package:enquetes/domain/entities/account_entity.dart';
import "package:meta/meta.dart";
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class FetchSecueCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class LocalLoadCurrentAccount {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    final token = await fetchSecureCacheStorage.fetchSecure("token");
    return AccountEntity(token);
  }
}

main() {
  LocalLoadCurrentAccount sut;
  String token;
  FetchSecueCacheStorageSpy fetchSecureCacheStorage;

  setUp(() {
    fetchSecureCacheStorage = FetchSecueCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
    token = faker.guid.guid();
  });

  test("Should call FetchSecureCacheStorage with correct value", () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure("token"));
  });

  test("Should return an AccountEntity", () async {
    when(fetchSecureCacheStorage.fetchSecure(any))
        .thenAnswer((_) async => token);

    final future = await sut.load();

    expect(future, AccountEntity(token));
  });
}

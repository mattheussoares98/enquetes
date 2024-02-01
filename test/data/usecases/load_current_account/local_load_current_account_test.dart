import "package:meta/meta.dart";
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String key);
}

class FetchSecueCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class LocalLoadCurrentAccount {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure("token");
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
}

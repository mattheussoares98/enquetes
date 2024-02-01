import 'package:enquetes/domain/entities/account_entity.dart';
import 'package:enquetes/domain/helpers/helpers.dart';
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
    try {
      final token = await fetchSecureCacheStorage.fetchSecure("token");
      return AccountEntity(token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

main() {
  LocalLoadCurrentAccount sut;
  String token;
  FetchSecueCacheStorageSpy fetchSecureCacheStorage;

  PostExpectation mockFetchSecure() {
    return when(fetchSecureCacheStorage.fetchSecure(any));
  }

  void mockFetchSecureCall() async {
    mockFetchSecure().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockFetchSecure().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecueCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
    token = faker.guid.guid();
    mockFetchSecureCall();
  });

  test("Should call FetchSecureCacheStorage with correct value", () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure("token"));
  });

  test("Should return an AccountEntity", () async {
    final future = await sut.load();

    expect(future, AccountEntity(token));
  });

  test("Should return error on fetchSecureCacheStorage fails", () async {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

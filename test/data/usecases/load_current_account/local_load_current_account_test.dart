import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:enquetes/data/cache/cache.dart';
import 'package:enquetes/data/usecases/load_current_account/load_current_account.dart';

import 'package:enquetes/domain/entities/account_entity.dart';
import 'package:enquetes/domain/helpers/helpers.dart';

class FetchSecueCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

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

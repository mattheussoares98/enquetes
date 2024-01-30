import 'package:enquetes/data/cache/cache.dart';
import 'package:enquetes/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class SaveStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  SaveStorageAdapter({@required this.secureStorage});

  Future<void> saveSecure(
      {@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

main() {
  SaveStorageAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SaveStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  void mockSaveSecureError() {
    when(secureStorage.write(key: anyNamed("key"), value: anyNamed("value")))
        .thenThrow(DomainError.unexpected);
  }

  test("Should call save secure with correct values", () async {
    await sut.saveSecure(key: key, value: value);

    verify(
      secureStorage.write(key: key, value: value),
    );
  });

  test("Should throw if save secure throws", () {
    mockSaveSecureError();
    final future = sut.saveSecure(key: key, value: value);

    expect(future, throwsA(DomainError.unexpected));
  });
}

import 'package:faker/faker.dart';
import 'package:enquetes/domain/helpers/domain_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enquetes/infra/cache/cache.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

main() {
  LocalStorageAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
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

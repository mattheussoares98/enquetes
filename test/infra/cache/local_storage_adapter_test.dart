import 'package:enquetes/data/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
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

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SaveStorageAdapter(secureStorage: secureStorage);
  });

  test("Should call save secure with correct values", () async {
    final key = faker.lorem.word();
    final value = faker.guid.guid();
    await sut.saveSecure(key: key, value: value);

    verify(
      secureStorage.write(key: key, value: value),
    );
  });
}

import 'package:enquetes/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart';
import "package:meta/meta.dart";

import 'package:enquetes/ui/pages/splash/splash.dart';
import 'package:enquetes/domain/usecases/usecases.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  var _navigateTo = RxString();
  Stream<String> get navigateToStream => _navigateTo.stream;

  Future<void> checkAccount() async {
    final account = await loadCurrentAccount.load();
    _navigateTo.value = account.isNull ? "/login" : "/surveys";
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashPresenter sut;

  mockLoadCurrentAccount({AccountEntity account}) {
    when(loadCurrentAccount.load()).thenAnswer((_) async => account);
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
  });
  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(
      expectAsync1(
        (page) => expect(page, "/surveys"),
      ),
    );

    await sut.checkAccount();
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);
    sut.navigateToStream.listen(
      expectAsync1(
        (page) => expect(page, "/login"),
      ),
    );

    await sut.checkAccount();
  });
}

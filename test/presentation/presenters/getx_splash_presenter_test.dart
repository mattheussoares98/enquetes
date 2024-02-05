import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/helpers/helpers.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:enquetes/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashPresenter sut;

  PostExpectation mockLoadCurrentAccountCall() =>
      when(loadCurrentAccount.load());

  mockLoadCurrentAccount({AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(DomainError.unexpected);
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

  test('Should go to login page on error', () async {
    mockLoadCurrentAccountError();

    sut.navigateToStream.listen(
      expectAsync1(
        (page) => expect(page, "/login"),
      ),
    );

    await sut.checkAccount();
  });
}

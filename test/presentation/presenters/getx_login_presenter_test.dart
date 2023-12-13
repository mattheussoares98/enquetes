import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/helpers/helpers.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:enquetes/presentation/presenters/presenters.dart';
import '../mocks/mocks.dart';

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  late GetxLoginPresenter sut;
  late AuthenticationSpy authentication;
  late ValidationSpy validation;
  late String email;
  late String password;

  mockValidationCall(String? field) =>
      when(() => validation.validate(field: field, value: any(named: 'value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  mockAuthenticationCall() => when(
        () => authentication.auth(any()),
      );

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer(
      (realInvocation) async => AccountEntity(
        faker.guid.guid(),
      ),
    );
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
    );

    mockValidation();
    mockAuthentication();
  });

  setUpAll(() {
    email = faker.internet.email();
    password = faker.internet.password();
    registerFallbackValue(
        AuthenticationParams(email: email, password: password));
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit error if email validation fails', () {
    validation.mockValidationError(value: "error");

    sut.emailErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit no error if email validation succeeds', () {
    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should emit error if password validation fails', () {
    validation.mockValidationError(value: "error");

    sut.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit no error if password validation succeeds', () {
    sut.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit form invalid if any field is invalid', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit form invalid if any field is invalid', () {
    mockValidation(field: 'password', value: 'error');

    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit form valid if form is valid', () async {
    expectLater(sut.isFormValidStream!, emitsInOrder([false, true]));
    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, null)));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });
  test('Should call authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(
      () => authentication.auth(
        AuthenticationParams(email: email, password: password),
        //está passando um objeto como parâmetro. Só está funcionando porque usou a dependência Equatable no AuthenticationParams
      ),
    ).called(1);
  });
  test('Should emit correct events on Authentication succes', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });
  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream!.listen(
      expectAsync1(
        (error) => expect(error, "Credenciais inválidas."),
      ),
    );

    await sut.auth();
  });
  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream!.listen(
      expectAsync1(
        (error) =>
            expect(error, "Algo errado aconteceu. Tente novamente em breve."),
      ),
    );

    await sut.auth();
  });
}

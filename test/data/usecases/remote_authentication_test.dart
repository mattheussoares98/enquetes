import 'package:enquetes/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:enquetes/data/http/http.dart';
import 'package:enquetes/data/usecases/remote_authentication.dart';
import 'package:enquetes/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClient httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });
  test(
    "Should call HttpCient with correct value",
    () async {
      when(httpClient.request(
              url: anyNamed("url"),
              method: anyNamed("method"),
              body: anyNamed("body")))
          .thenAnswer((_) async => {
                "accessToken": faker.guid.guid(),
                "name": faker.person.name(),
              });

      await sut.auth(params);

      verify(httpClient.request(
        url: url,
        method: "post",
        body: {
          "email": params.email,
          "password": params.password,
        },
      ));
    },
  );

  test(
    "Should trow UnexpectedError if HttpClient returns 400",
    () async {
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.badRequest);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
  test(
    "Should trow UnexpectedError if HttpClient returns 404",
    () async {
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.notFound);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
  test(
    "Should trow UnexpectedError if HttpClient returns 500",
    () async {
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.serverError);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
  test(
    "Should trow UnexpectedError if HttpClient returns 401",
    () async {
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.unauthorized);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    "Should trow an Account if HttpClient returns 200",
    () async {
      final accessToken = faker.guid.guid();

      when(httpClient.request(
              url: anyNamed("url"),
              method: anyNamed("method"),
              body: anyNamed("body")))
          .thenAnswer((_) async => {
                "accessToken": accessToken,
                "name": faker.person.name(),
              });

      final account = await sut.auth(params);

      expect(account!.token, accessToken);
    },
  );
  test(
    "Should trow UnexpectedError if HttpClient returns 200 with invalid data",
    () async {
      when(httpClient.request(
              url: anyNamed("url"),
              method: anyNamed("method"),
              body: anyNamed("body")))
          .thenAnswer((_) async => {
                "anything": "anything",
              });

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}

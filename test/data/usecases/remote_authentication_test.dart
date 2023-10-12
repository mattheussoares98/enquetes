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

  Map mockValidData() => {
        "accessToken": faker.guid.guid(),
        "name": faker.person.name(),
      };

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed("url"),
      method: anyNamed("method"),
      body: anyNamed("body")));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

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
    mockHttpData(mockValidData());
  });
  test(
    "Should call HttpCient with correct value",
    () async {
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
      mockHttpError(HttpError.badRequest);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
  test(
    "Should trow UnexpectedError if HttpClient returns 404",
    () async {
      mockHttpError(HttpError.notFound);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
  test(
    "Should trow UnexpectedError if HttpClient returns 500",
    () async {
      mockHttpError(HttpError.serverError);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
  test(
    "Should trow UnexpectedError if HttpClient returns 401",
    () async {
      mockHttpError(HttpError.unauthorized);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    "Should trow an Account if HttpClient returns 200",
    () async {
      final validData = mockValidData();

      mockHttpData(validData);

      final account = await sut.auth(params);

      expect(account!.token, validData["accessToken"]);
    },
  );
  test(
    "Should trow UnexpectedError if HttpClient returns 200 with invalid data",
    () async {
      mockHttpData({
        "anything": "anything",
      });

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}

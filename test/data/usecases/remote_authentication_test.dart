import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:enquetes/data/http/http.dart';
import 'package:enquetes/data/usecases/remote_authentication.dart';
import 'package:enquetes/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late final RemoteAuthentication sut;
  late final HttpClient httpClient;
  late final String url;
  late final AuthenticationParams params;

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
}

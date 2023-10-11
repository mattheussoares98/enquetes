import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:enquetes/domain/usecases/authentication.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void>? auth(AuthenticationParams params) async {
    final body = {
      "email": params.email,
      "password": params.password,
    };
    await httpClient.request(
      url: url,
      method: "post",
      body: body,
    );
  }
}

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
    Map? body,
  });
}

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
    //1º //sut = "System Under Test" ou "Sujeito Sob Teste"
  });
  test(
    "Should call HttpCient with correct value",
    () async {
      await sut.auth(params);
      //2º // o teste que vai fazer

      verify(httpClient.request(
        url: url,
        method: "post",
        body: {
          "email": params.email,
          "password": params.password,
        },
      ));
      //3º //o que é esperado
      //o verify utiliza o mockito
    },
  );
}

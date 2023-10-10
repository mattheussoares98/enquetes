import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void>? auth() async {
    await httpClient.request(url: url, method: "post");
  }
}

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test(
    "Should call HttpCient with correct value",
    () async {
      final httpClient = HttpClientSpy();
      final url = faker.internet.httpUrl();
      final sut = RemoteAuthentication(
        httpClient: httpClient,
        url: url,
      );
      //1º //sut = "System Under Test" ou "Sujeito Sob Teste"

      await sut.auth();
      //2º // o teste que vai fazer

      verify(httpClient.request(
        url: url,
        method: "post",
      ));
      //3º //o que é esperado
      //o verify utiliza o mockito
    },
  );
}

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<Response> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    return await client.post(Uri.parse(url));
  }
}

void main() {
  group("post", () {
    test("Should call post with correct values", () async {
      final client = ClientSpy();
      final sut = HttpAdapter(client);
      final url = faker.internet.httpUrl();

      await sut.request(url: url, method: "post");

      verify(client.post(Uri.parse(url)));
    });
  });
}

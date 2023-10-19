import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements Client {}

class HttpAdapter {
  final Client client;

  HttpAdapter({required this.client});

  Future<Response> request({
    required Uri url,
    required String method,
  }) async {
    return await client.post(url);
  }
}

void main() {
  late HttpAdapter sut;
  late Uri url;
  late Client client;

  setUp(() {
    client = HttpClientSpy();
    sut = HttpAdapter(client: client);
    url = Uri.parse(faker.internet.httpUrl());

    when(() => client.post(url))
        .thenAnswer((_) async => Response('Hello, World!', 200));
  });
  test(
    "Should call HttpCient with correct value",
    () async {
      await sut.request(url: url, method: "post");

      verify(() => client.post(url));
    },
  );
}

import 'dart:convert';

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
    Map<String, String>? body,
  }) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "application/json",
    };
    return await client.post(
      url,
      headers: headers,
      body: json.encode(body),
    );
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

    when(
      () => client.post(
        url,
        headers: any(named: "headers"),
        body: any(named: "body"),
      ),
    ).thenAnswer((_) async => Response('anything', 200));
  });
  test("Should call HttpCient with correct value", () async {
    await sut.request(url: url, method: "post", body: {"any": "any"});

    verify(
      () => client.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
        body: json.encode({"any": "any"}),
      ),
    );
  });
}

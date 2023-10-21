import 'dart:convert';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:enquetes/data/http/http.dart';

class HttpClientSpy extends Mock implements Client {}

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter({required this.client});

  @override
  Future<Map> request({
    required String? url,
    required String? method,
    Map? body,
  }) async {
    const Map<String, String> headers = {
      "Content-Type": "application/json",
      "accept": "application/json",
    };

    final jsonBody = body == null ? null : json.encode(body);

    final response = await client.post(
      Uri.parse(url!),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return response.body.isEmpty ? {} : json.decode(response.body);
    } else {
      return {};
    }
  }
}

void main() {
  late HttpAdapter sut;
  late String url;
  late Client client;
  late Uri uri;

  mockRequest() => when(
        () => client.post(
          uri,
          headers: any(named: "headers"),
          body: any(named: "body"),
        ),
      );

  void mockResponse({
    required int statusCode,
    String? body = '{"any": "any"}',
  }) {
    mockRequest().thenAnswer(
      (_) async => Response(body!, statusCode),
    );
  }

  setUp(() {
    client = HttpClientSpy();
    sut = HttpAdapter(client: client);
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);

    mockResponse(statusCode: 200);
    mockResponse(statusCode: 200, body: "");
  });
  test("Should call HttpCient with correct value", () async {
    await sut.request(url: url, method: "post", body: {"any": "any"});

    verify(
      () => client.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
        },
        body: json.encode({"any": "any"}),
      ),
    );
  });
  test("Should call post without body", () async {
    await sut.request(url: url, method: "post");

    verify(
      () => client.post(
        uri,
        headers: any(named: "headers"),
      ),
    );
  });

  test("Should return data if post return 200", () async {
    final response = await sut.request(url: url, method: "post");

    expect(response, {});
  });

  test("Should return null if post return 200 with no data", () async {
    final response = await sut.request(url: url, method: "post");

    expect(response, {});
  });

  test("Should return null if post returns 204", () async {
    mockResponse(statusCode: 204, body: "");

    final response = await sut.request(url: url, method: "post");

    expect(response, {});
  });

  test("Should return null if post returns 204", () async {
    mockResponse(statusCode: 204);

    final response = await sut.request(url: url, method: "post");

    expect(response, {});
  });
}

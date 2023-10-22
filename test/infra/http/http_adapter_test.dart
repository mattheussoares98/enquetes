import 'dart:convert';
import 'package:enquetes/infra/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements Client {}

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

  test("Should return null if post returns 204 with no data", () async {
    mockResponse(statusCode: 204);

    final response = await sut.request(url: url, method: "post");

    expect(response, {});
  });
}

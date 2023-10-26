import 'dart:convert';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import "package:mockito/mockito.dart";
import 'package:test/test.dart';

import 'package:enquetes/data/http/http.dart';
import 'package:enquetes/infra/http/http.dart';

class HttpClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  String url;
  Client client;
  Uri uri;

  PostExpectation mockRequest() => when(
      client.post(any, body: anyNamed('body'), headers: anyNamed('headers')));

  void mockResponse(int statusCode,
          {String body = '{"any_key":"any_value"}'}) =>
      mockRequest().thenAnswer((_) async => Response(body, statusCode));

  void mockError() {
    mockRequest().thenThrow(Exception());
  }

  setUp(() {
    client = HttpClientSpy();
    sut = HttpAdapter(client: client);
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
  });

  group("shared", () {
    test("Should throw ServerError if invalid method is provided", () async {
      final future = sut.request(
        url: url,
        method: "invalid method",
      );

      expect(future, throwsA(HttpError.serverError));
    });
  });
  group("post", () {
    test("Should call HttpCient with correct value", () async {
      mockResponse(200, body: "");

      await sut.request(url: url, method: "post", body: {"any": "any"});

      verify(
        client.post(
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
      mockResponse(200);

      await sut.request(url: url, method: "post");

      verify(
        client.post(
          uri,
          headers: anyNamed("headers"),
        ),
      );
    });

    test("Should return data if post return 200", () async {
      mockResponse(200);

      final response = await sut.request(url: url, method: "post");

      expect(response, {"any_key": "any_value"});
    });

    test("Should return null if post return 200 with no data", () async {
      mockResponse(200);

      final response = await sut.request(url: url, method: "post");

      expect(response, {"any_key": "any_value"});
    });

    test("Should return null if post returns 204", () async {
      mockResponse(204, body: "");

      final response = await sut.request(url: url, method: "post");

      expect(response, {});
    });

    test("Should return null if post returns 204 with no data", () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: "post");

      expect(response, {});
    });

    test("Should return BadRequest if post returns 400", () async {
      mockResponse(400);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.badRequest));
    });

    test("Should return UnauthorizedError if post returns 401", () async {
      mockResponse(401);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.unauthorized));
    });

    test("Should return Forbidden if post returns 403", () async {
      mockResponse(403);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.forbidden));
    });

    test("Should return NotFound if post returns 404", () async {
      mockResponse(404);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.notFound));
    });

    test("Should return ServerError if post returns 500", () async {
      mockResponse(500);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.serverError));
    });

    test("Should return ServerError if post throws", () async {
      mockError();

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.serverError));
    });
  });
}

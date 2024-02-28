import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'package:enquetes/data/http/http.dart';
import 'package:mockito/mockito.dart';

class RemoteLoadSurveys {
  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveys({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> load() async {
    await httpClient.request(url: url, method: "get");
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

main() {
  RemoteLoadSurveys sut;
  HttpClientSpy httpClient;
  String url;
  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(
      httpClient: httpClient,
      url: url,
    );
  });
  test(
    "Should call RemoteLoadSurvey with correct values",
    () {
      sut.load();

      verify(httpClient.request(url: url, method: "get"));
    },
  );
}

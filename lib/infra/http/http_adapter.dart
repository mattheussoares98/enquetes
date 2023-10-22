import 'package:http/http.dart';
import 'dart:convert';

import '../../data/http/http.dart';

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

    final Response response;

    try {
      if (method == "post") {
        response = await client.post(
          Uri.parse(url!),
          headers: headers,
          body: jsonBody,
        );
      } else {
        response = Response("", 500);
      }
    } catch (error) {
      print("error: $error");
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? {} : json.decode(response.body);
    } else if (response.statusCode == 204) {
      return {};
    } else if (response.statusCode == 400) {
      throw (HttpError.badRequest);
    } else if (response.statusCode == 401) {
      throw (HttpError.unauthorized);
    } else if (response.statusCode == 403) {
      throw (HttpError.forbidden);
    } else if (response.statusCode == 404) {
      throw (HttpError.notFound);
    } else {
      throw (HttpError.serverError);
    }
  }
}

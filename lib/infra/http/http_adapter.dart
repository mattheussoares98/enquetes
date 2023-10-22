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

    final response = await client.post(
      Uri.parse(url!),
      headers: headers,
      body: jsonBody,
    );

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? {} : json.decode(response.body);
    } else if (response.statusCode == 204) {
      return {};
    } else {
      throw (HttpError.badRequest);
    }
  }
}

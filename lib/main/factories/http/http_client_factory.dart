import '../../../data/http/http.dart';
import '../../../infra/http/http.dart';

import 'package:http/http.dart';

HttpClient makeHttpAdapter() {
  final client = Client();
  final httpAdapter = HttpAdapter(client);

  return httpAdapter;
}

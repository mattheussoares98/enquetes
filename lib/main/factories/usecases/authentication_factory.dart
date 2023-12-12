import '../../../data/usecases/usecases.dart';
import '../factories.dart';

RemoteAuthentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl("login"),
  );
}

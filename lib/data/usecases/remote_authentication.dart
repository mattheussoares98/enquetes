import '../../domain/usecases/usecases.dart';
import '../http/http.dart';
import '../../domain/helpers/helpers.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void>? auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    //poderia passar o e-mail e senha direto nos parâmetros da função mas ia
    //quebrar o princípio de responsabilidade única. Por isso criou um factory
    //na RemoteAuthenticationParams para usar o toJson dessa classe

    try {
      await httpClient.request(
        url: url,
        method: "post",
        body: body,
      );
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;
  final Map? body;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
    this.body,
  });

  factory RemoteAuthenticationParams.fromDomain(
    AuthenticationParams params,
  ) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.password,
      );

  Map toJson() => {"email": email, "password": password};
}

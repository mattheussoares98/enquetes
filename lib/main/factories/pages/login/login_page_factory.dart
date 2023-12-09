import 'package:enquetes/data/usecases/remote_authentication.dart';
import 'package:enquetes/infra/http/http.dart';
import 'package:enquetes/presentation/presenters/presenters.dart';
import 'package:enquetes/ui/pages/login/login_page.dart';
import 'package:enquetes/validation/validators/email_validation.dart';
import 'package:enquetes/validation/validators/required_field_validation.dart';
import 'package:enquetes/validation/validators/validation_composite.dart';
import 'package:http/http.dart';

LoginPage makeLoginPage() {
  const url = "http://fordevs.herokuapp.com/api/login";
  final client = Client();
  final httpAdapter = HttpAdapter(client: client);
  final remoteAuthentication = RemoteAuthentication(
    httpClient: httpAdapter,
    url: url,
  );
  final validationComposite = ValidationComposite([
    RequiredFieldValidation("email"),
    EmailValidation("email"),
    RequiredFieldValidation("password"),
  ]);
  final streamLoginPresenter = StreamLoginPresenter(
    validation: validationComposite,
    authentication: remoteAuthentication,
  );
  return LoginPage(streamLoginPresenter);
}

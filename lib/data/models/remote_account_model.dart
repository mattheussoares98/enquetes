import 'package:enquetes/data/http/http.dart';
import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map? json) {
    if (json != null && !json.containsKey("accessToken")) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json!["accessToken"]);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}

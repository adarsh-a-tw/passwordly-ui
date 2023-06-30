import 'package:passwordly/networking/passwordly_end_point.dart';
import 'package:passwordly/networking/request_builders/create_secret_request_builder.dart';
import 'package:passwordly/networking/api_client/passwordly_api_client.dart';

class SecretDataProvider {
  final PasswordlyApiClient _client;

  SecretDataProvider(this._client);

  Future<void> createSecret(
    String vaultId,
    String name,
    String type,
    String username,
    String password,
  ) async {
    final request = _client.configureRequest(
      PasswordlyEndPoint.createSecret,
      body: CreateSecretRequestBuilder(
        name: name,
        type: type,
        username: username,
        password: password,
      ).toRequestBody(),
      params: {"id": vaultId},
    );
    await _client.send(request);
  }
}

import 'package:passwordly/networking/passwordly_end_point.dart';
import 'package:passwordly/networking/request_builders/login_request_builder.dart';
import 'package:passwordly/networking/response_builders/login_response.dart';
import 'package:passwordly/networking/api_client/passwordly_api_client.dart';

class AuthDataProvider {
  final PasswordlyApiClient _client;

  AuthDataProvider(this._client);

  Future<void> login(String username, String password) async {
    final requestBody = LoginRequestBuilder(
      username: username,
      password: password,
    ).toRequestBody();
    final request = _client.configureRequest(
      PasswordlyEndPoint.login,
      body: requestBody,
      authNeeded: false,
    );

    final resp = LoginResponse.fromJson(await _client.send(request));
    _client.configureAuth(resp.refreshToken, resp.accessToken);
  }

  void logout() {
    _client.resetAuth();
  }
}

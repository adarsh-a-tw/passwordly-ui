import 'package:passwordly/networking/passwordly_end_point.dart';
import 'package:passwordly/networking/response_builders/fetch_profile_response.dart';
import 'package:passwordly/networking/api_client/passwordly_api_client.dart';

class UserDataProvider {
  final PasswordlyApiClient _client;

  UserDataProvider(this._client);

  Future<FetchProfileResponse> fetchProfile() async {
    final request = _client.configureRequest(PasswordlyEndPoint.fetchProfile);
    return FetchProfileResponse.fromJson(await _client.send(request));
  }
}

import 'package:passwordly/data/models/user.dart';
import 'package:passwordly/networking/service/passwordly_api_service.dart';

class AuthRepository {
  final PasswordlyApiService _service;

  AuthRepository(this._service);

  Future<void> login(String username, String password) async {
    await _service.login(username, password);
  }

  void logout() {
    _service.logout();
  }

  bool isAuthenticated() {
    return _service.isAuthenticated;
  }

  Future<User> fetchProfile() async {
    return User.fromResponse(await _service.fetchProfile());
  }
}

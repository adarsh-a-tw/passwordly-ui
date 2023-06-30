import 'package:passwordly/networking/data_providers/auth_data_provider.dart';

class AuthRepository {
  final AuthDataProvider _dataProvider;

  AuthRepository(this._dataProvider);

  Future<void> login(String username, String password) async {
    await _dataProvider.login(username, password);
  }

  void logout() {
    _dataProvider.logout();
  }
}

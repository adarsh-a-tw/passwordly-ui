import 'package:passwordly/data/models/user.dart';
import 'package:passwordly/networking/data_providers/user_data_provider.dart';

class UserRepository {
  final UserDataProvider _dataProvider;

  UserRepository(this._dataProvider);

  Future<User> fetchProfile() async {
    return User.fromResponse(await _dataProvider.fetchProfile());
  }

  Future<void> signup(String username, String email, String password) async {
    await _dataProvider.signup(username, email, password);
  }
}

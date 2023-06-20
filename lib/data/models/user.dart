import 'package:passwordly/networking/response_builders/fetch_profile_response.dart';

class User {
  final String id;
  final String username;
  final String email;

  User(this.id, this.username, this.email);

  factory User.fromResponse(FetchProfileResponse response) {
    return User(
      response.id,
      response.username,
      response.email,
    );
  }
}

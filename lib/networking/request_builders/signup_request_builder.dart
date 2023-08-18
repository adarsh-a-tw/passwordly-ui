import 'request_builder.dart';

class SignupRequestBuilder extends RequestBuilder {
  final String username;
  final String email;
  final String password;

  SignupRequestBuilder(this.username, this.email, this.password);

  @override
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
    };
  }
}

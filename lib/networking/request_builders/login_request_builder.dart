import 'request_builder.dart';

class LoginRequestBuilder extends RequestBuilder {
  final String username;
  final String password;

  LoginRequestBuilder({required this.username, required this.password});

  @override
  Map<String, dynamic> toJson() {
    return {"username": username, "password": password};
  }
}

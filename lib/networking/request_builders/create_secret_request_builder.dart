import 'package:passwordly/networking/request_builders/request_builder.dart';

class CreateSecretRequestBuilder extends RequestBuilder {
  final String name;
  final String type;
  final String username;
  final String password;

  CreateSecretRequestBuilder({
    required this.type,
    required this.username,
    required this.password,
    required this.name,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "type": type,
      "username": username,
      "password": password
    };
  }
}

import 'package:passwordly/networking/response_builders/secret_response.dart';

class Secret {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SecretEntity entity;

  Secret(this.id, this.name, this.createdAt, this.updatedAt, this.entity);

  factory Secret.fromResponse(SecretResponse response) {
    Credential credential = Credential(
      response.username ?? "",
      response.password ?? "",
    );
    return Secret(
      response.id,
      response.name,
      DateTime.fromMillisecondsSinceEpoch(response.createdAt * 1000).toLocal(),
      DateTime.fromMillisecondsSinceEpoch(response.updatedAt * 1000).toLocal(),
      credential,
    );
  }
}

enum SecretType {
  credential,
  key,
  document;
}

abstract class SecretEntity {}

class Credential extends SecretEntity {
  final String username;
  final String password;

  Credential(this.username, this.password);
}

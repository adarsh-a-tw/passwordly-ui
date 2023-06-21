import 'package:passwordly/data/models/secret.dart';
import 'package:passwordly/networking/response_builders/vault_response.dart';

class Vault {
  final String id;
  final String name;
  final List<Secret> secrets;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vault(this.id, this.name, this.createdAt, this.updatedAt, this.secrets);

  factory Vault.fromResponse(VaultResponse response) {
    return Vault(
      response.id,
      response.name,
      DateTime.fromMillisecondsSinceEpoch(response.createdAt * 1000).toLocal(),
      DateTime.fromMillisecondsSinceEpoch(response.updatedAt * 1000).toLocal(),
      (response.secrets ?? []).map((e) => Secret.fromResponse(e)).toList(),
    );
  }
}

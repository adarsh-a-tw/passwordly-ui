import 'package:passwordly/networking/response_builders/secret_response.dart';

class VaultResponse {
  final String id;
  final String name;
  final List<SecretResponse>? secrets;
  final int createdAt;
  final int updatedAt;

  factory VaultResponse.fromJson(Map<String, dynamic> json) {
    final List<SecretResponse> secrets;
    if (json.containsKey("secrets")) {
      secrets = (json["secrets"] as List<dynamic>)
          .map((secretJson) => SecretResponse.fromJson(secretJson))
          .toList();
    } else {
      secrets = [];
    }
    return VaultResponse(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      secrets: secrets,
      createdAt: json["created_at"] ?? 0,
      updatedAt: json["updated_at"] ?? 0,
    );
  }

  VaultResponse({
    required this.id,
    required this.name,
    required this.secrets,
    required this.createdAt,
    required this.updatedAt,
  });
}

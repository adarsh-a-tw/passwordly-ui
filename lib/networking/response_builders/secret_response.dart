class SecretResponse {
  final String id;
  final String name;
  final String type;
  final int createdAt;
  final int updatedAt;
  final String? username;
  final String? password;
  final String? value;
  final String? document;

  factory SecretResponse.fromJson(Map<String, dynamic> json) {
    return SecretResponse(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      createdAt: json["created_at"] ?? 0,
      updatedAt: json["updated_at"] ?? 0,
      username: json["username"],
      password: json["password"],
      value: json["value"],
      document: json["document"],
    );
  }

  SecretResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
    required this.password,
    required this.value,
    required this.document,
  });
}

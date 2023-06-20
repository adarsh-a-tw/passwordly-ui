class VaultResponse {
  final String id;
  final String name;
  final List<int>? secrets;
  final int createdAt;
  final int updatedAt;

  factory VaultResponse.fromJson(Map<String, dynamic> json) {
    return VaultResponse(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      secrets: json["secrets"] ?? [],
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

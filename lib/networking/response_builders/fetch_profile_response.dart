class FetchProfileResponse {
  final String id;
  final String username;
  final String email;

  FetchProfileResponse({
    required this.id,
    required this.username,
    required this.email,
  });

  factory FetchProfileResponse.fromJson(Map<String, dynamic> json) {
    return FetchProfileResponse(
      id: json["id"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
    );
  }
}

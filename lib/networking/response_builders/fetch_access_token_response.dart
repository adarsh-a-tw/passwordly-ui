class FetchAccessTokenResponse {
  final String accessToken;

  FetchAccessTokenResponse({required this.accessToken});

  factory FetchAccessTokenResponse.fromJson(Map<String, dynamic> json) {
    return FetchAccessTokenResponse(
      accessToken: json["access_token"] ?? "",
    );
  }
}

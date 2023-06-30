import 'package:passwordly/networking/response_builders/vault_response.dart';

class FetchVaultListResponse {
  final List<VaultResponse> vaults;

  FetchVaultListResponse({required this.vaults});

  factory FetchVaultListResponse.fromJson(Map<String, dynamic> json) {
    return FetchVaultListResponse(
      vaults: ((json["vaults"] ?? []) as List<dynamic>)
          .map((vaultResponse) => VaultResponse.fromJson(vaultResponse))
          .toList(),
    );
  }
}

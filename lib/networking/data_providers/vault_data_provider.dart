import 'package:passwordly/networking/passwordly_end_point.dart';
import 'package:passwordly/networking/request_builders/create_vault_request_builder.dart';
import 'package:passwordly/networking/response_builders/fetch_vault_list_response.dart';
import 'package:passwordly/networking/response_builders/vault_response.dart';
import 'package:passwordly/networking/api_client/passwordly_api_client.dart';

class VaultDataProvider {
  final PasswordlyApiClient _client;

  VaultDataProvider(this._client);

  Future<void> createVault(String name) async {
    final request = _client.configureRequest(
      PasswordlyEndPoint.createVault,
      body: CreateVaultRequestBuilder(name: name).toRequestBody(),
    );
    await _client.send(request);
  }

  Future<FetchVaultListResponse> fetchVaults() async {
    final request = _client.configureRequest(PasswordlyEndPoint.fetchVaults);
    return FetchVaultListResponse.fromJson(await _client.send(request));
  }

  Future<VaultResponse> fetchVaultDetails(String id) async {
    final request = _client.configureRequest(
      PasswordlyEndPoint.vaultDetails,
      params: {"id": id},
    );
    return VaultResponse.fromJson(await _client.send(request));
  }

  Future<void> deleteVault(String id) async {
    final request = _client.configureRequest(
      PasswordlyEndPoint.deleteVault,
      params: {"id": id},
    );
    await _client.send(request);
  }
}

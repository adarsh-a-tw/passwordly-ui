import 'package:passwordly/data/models/vault.dart';
import 'package:passwordly/networking/service/passwordly_api_service.dart';

class VaultRepository {
  final PasswordlyApiService _service;

  VaultRepository(this._service);

  Future<List<Vault>> fetchVaults() async {
    final rawResponse = await _service.fetchVaults();
    return rawResponse.vaults.map((e) => Vault.fromResponse(e)).toList();
  }

  Future<Vault> fetchVault(String id) async {
    final rawResponse = await _service.fetchVaultDetails(id);
    return Vault.fromResponse(rawResponse);
  }

  Future<void> createVault(String name) async {
    await _service.createVault(name);
  }

  Future<void> deleteVault(String id) async {
    await _service.deleteVault(id);
  }
}

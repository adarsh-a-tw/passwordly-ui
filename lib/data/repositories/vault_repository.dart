import 'package:passwordly/data/models/vault.dart';
import 'package:passwordly/networking/data_providers/vault_data_provider.dart';

class VaultRepository {
  final VaultDataProvider _dataProvider;

  VaultRepository(this._dataProvider);

  Future<List<Vault>> fetchVaults() async {
    final rawResponse = await _dataProvider.fetchVaults();
    return rawResponse.vaults
        .map(
          (vaultResponse) => Vault.fromResponse(vaultResponse),
        )
        .toList();
  }

  Future<Vault> fetchVault(String id) async {
    final rawResponse = await _dataProvider.fetchVaultDetails(id);
    return Vault.fromResponse(rawResponse);
  }

  Future<void> createVault(String name) async {
    await _dataProvider.createVault(name);
  }

  Future<void> deleteVault(String id) async {
    await _dataProvider.deleteVault(id);
  }
}

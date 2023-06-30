import 'package:passwordly/data/models/secret.dart';
import 'package:passwordly/networking/data_providers/secret_data_provider.dart';

class SecretRepository {
  final SecretDataProvider _dataProvider;

  SecretRepository(this._dataProvider);

  Future<void> createSecret(
    String vaultId,
    String secretName,
    SecretType type,
    String username,
    String password,
  ) async {
    await _dataProvider.createSecret(
      vaultId,
      secretName,
      type.toString(),
      username,
      password,
    );
  }
}

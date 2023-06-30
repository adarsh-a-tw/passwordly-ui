import 'package:passwordly/data/repositories/auth_repository.dart';
import 'package:passwordly/data/repositories/secret_repository.dart';
import 'package:passwordly/data/repositories/user_repository.dart';
import 'package:passwordly/data/repositories/vault_repository.dart';
import 'package:passwordly/networking/api_client/passwordly_api_client.dart';
import 'package:passwordly/networking/data_providers/auth_data_provider.dart';
import 'package:passwordly/networking/data_providers/secret_data_provider.dart';
import 'package:passwordly/networking/data_providers/user_data_provider.dart';
import 'package:passwordly/networking/data_providers/vault_data_provider.dart';

class PasswordlyRepositoryProvider {
  late final AuthRepository _authRepository;
  late final SecretRepository _secretRepository;
  late final UserRepository _userRepository;
  late final VaultRepository _vaultRepository;

  void configure(PasswordlyApiClient client) {
    _authRepository = AuthRepository(AuthDataProvider(client));
    _secretRepository = SecretRepository(SecretDataProvider(client));
    _userRepository = UserRepository(UserDataProvider(client));
    _vaultRepository = VaultRepository(VaultDataProvider(client));
  }

  static PasswordlyRepositoryProvider? _instance;

  PasswordlyRepositoryProvider._();

  factory PasswordlyRepositoryProvider() {
    _instance ??= PasswordlyRepositoryProvider._();
    return _instance!;
  }

  AuthRepository get authRepository {
    return _authRepository;
  }

  SecretRepository get secretRepository {
    return _secretRepository;
  }

  UserRepository get userRepository {
    return _userRepository;
  }

  VaultRepository get vaultRepository {
    return _vaultRepository;
  }
}

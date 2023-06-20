part of 'vault_detail_cubit.dart';

@immutable
abstract class VaultDetailState {}

class VaultDetailLoading extends VaultDetailState {}

class VaultDetailError extends VaultDetailState {
  final String message;

  VaultDetailError(this.message);
}

class VaultDetailSuccess extends VaultDetailState {
  final Vault vault;

  VaultDetailSuccess(this.vault);
}

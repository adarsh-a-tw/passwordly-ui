part of 'vault_create_cubit.dart';

@immutable
abstract class VaultCreateState {}

class VaultCreateInitial extends VaultCreateState {}

class VaultCreateLoading extends VaultCreateState {}

class VaultCreateError extends VaultCreateState {
  final String message;

  VaultCreateError(this.message);
}

class VaultCreateSuccess extends VaultCreateState {}

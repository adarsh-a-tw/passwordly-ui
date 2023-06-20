part of 'vault_delete_cubit.dart';

@immutable
abstract class VaultDeleteState {}

class VaultDeleteInitial extends VaultDeleteState {}

class VaultDeleteLoading extends VaultDeleteState {}

class VaultDeleteError extends VaultDeleteState {
  final String message;

  VaultDeleteError(this.message);
}

class VaultDeleteSuccess extends VaultDeleteState {}

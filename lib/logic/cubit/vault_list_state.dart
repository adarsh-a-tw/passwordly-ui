part of 'vault_list_cubit.dart';

@immutable
abstract class VaultListState {}

class VaultListLoading extends VaultListState {}

class VaultListError extends VaultListState {
  final String message;

  VaultListError(this.message);
}

class VaultListSuccess extends VaultListState {
  final List<Vault> vaults;

  VaultListSuccess(this.vaults);
}

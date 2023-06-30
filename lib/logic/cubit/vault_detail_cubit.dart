import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:passwordly/data/models/vault.dart';
import 'package:passwordly/data/repositories/vault_repository.dart';

part 'vault_detail_state.dart';

class VaultDetailCubit extends Cubit<VaultDetailState> {
  final VaultRepository repository;
  VaultDetailCubit(this.repository) : super(VaultDetailLoading());

  Future<void> fetchVaultDetails(String id) async {
    emit(VaultDetailLoading());
    try {
      final vault = await repository.fetchVault(id);
      emit(VaultDetailSuccess(vault));
    } catch (exception) {
      emit(VaultDetailError(exception.toString()));
    }
  }
}

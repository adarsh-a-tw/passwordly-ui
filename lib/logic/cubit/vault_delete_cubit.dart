import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:passwordly/data/repositories/vault_repository.dart';

part 'vault_delete_state.dart';

class VaultDeleteCubit extends Cubit<VaultDeleteState> {
  final VaultRepository repository;

  VaultDeleteCubit(this.repository) : super(VaultDeleteInitial());

  void deleteVault(String id) async {
    emit(VaultDeleteLoading());
    try {
      await repository.deleteVault(id);
      emit(VaultDeleteSuccess());
    } catch (exception) {
      emit(VaultDeleteError(exception.toString()));
    }
  }
}

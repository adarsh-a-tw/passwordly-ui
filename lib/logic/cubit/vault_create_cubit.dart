import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:passwordly/data/repositories/vault_repository.dart';

part 'vault_create_state.dart';

class VaultCreateCubit extends Cubit<VaultCreateState> {
  final VaultRepository repository;
  VaultCreateCubit(this.repository) : super(VaultCreateInitial());

  void createVault(String name) async {
    emit(VaultCreateLoading());
    try {
      await repository.createVault(name);
      emit(VaultCreateSuccess());
    } catch (exception) {
      emit(VaultCreateError(exception.toString()));
    }
  }

  void resetState() {
    emit(VaultCreateInitial());
  }
}

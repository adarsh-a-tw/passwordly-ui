import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:passwordly/data/models/vault.dart';
import 'package:passwordly/data/repositories/vault_repository.dart';

part 'vault_list_state.dart';

class VaultListCubit extends Cubit<VaultListState> {
  final VaultRepository repository;

  VaultListCubit(this.repository) : super(VaultListLoading());

  void fetchVaults() async {
    emit(VaultListLoading());
    try {
      final vaults = await repository.fetchVaults();
      emit(VaultListSuccess(vaults));
    } catch (exception) {
      emit(VaultListError(exception.toString()));
    }
  }
}

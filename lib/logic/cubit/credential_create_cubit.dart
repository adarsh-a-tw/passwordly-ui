import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:passwordly/data/models/secret.dart';
import 'package:passwordly/data/repositories/secret_repository.dart';

part 'credential_create_state.dart';

class CredentialCreateCubit extends Cubit<CredentialCreateState> {
  final SecretRepository repository;
  CredentialCreateCubit(this.repository) : super(CredentialCreateInitial());

  Future<void> createCredential(
    String vaultId,
    String secretName,
    SecretType type,
    String username,
    String password,
  ) async {
    emit(CredentialCreateLoading());
    try {
      await repository.createSecret(
        vaultId,
        secretName,
        type,
        username,
        password,
      );
      emit(CredentialCreateSuccess());
    } catch (exception) {
      emit(CredentialCreateError(exception.toString()));
    }
  }

  void resetState() {
    emit(CredentialCreateInitial());
  }
}

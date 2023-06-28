part of 'credential_create_cubit.dart';

@immutable
abstract class CredentialCreateState {}

class CredentialCreateInitial extends CredentialCreateState {}

class CredentialCreateLoading extends CredentialCreateState {}

class CredentialCreateError extends CredentialCreateState {
  final String message;

  CredentialCreateError(this.message);
}

class CredentialCreateSuccess extends CredentialCreateState {}

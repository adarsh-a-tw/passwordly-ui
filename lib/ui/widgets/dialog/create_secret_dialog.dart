import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/data/models/secret.dart';
import 'package:passwordly/data/repositories/repository_provider.dart';
import 'package:passwordly/logic/cubit/credential_create_cubit.dart';
import 'package:passwordly/ui/widgets/forms/create_credential_form.dart';

class CreateSecretDialog extends StatelessWidget {
  final SecretType type;
  final String vaultId;
  const CreateSecretDialog({
    super.key,
    required this.vaultId,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CredentialCreateCubit>(
      create: (context) => CredentialCreateCubit(
        PasswordlyRepositoryProvider().secretRepository,
      ),
      child: CreateCredentialForm(
        vaultId: vaultId,
      ),
    );
  }
}

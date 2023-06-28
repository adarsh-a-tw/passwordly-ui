import 'package:flutter/material.dart';
import 'package:passwordly/data/models/secret.dart';
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
    return CreateCredentialForm(
      vaultId: vaultId,
    );
  }
}

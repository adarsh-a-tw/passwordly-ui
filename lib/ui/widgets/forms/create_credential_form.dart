import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/data/models/secret.dart';
import 'package:passwordly/logic/cubit/credential_create_cubit.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_alert_dialog.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_default_dialog.dart';
import 'package:passwordly/utils/passwordly_scaffold_messenger.dart';

class CreateCredentialForm extends StatefulWidget {
  const CreateCredentialForm({super.key, required this.vaultId});
  final String vaultId;

  @override
  State<CreateCredentialForm> createState() => _CreateCredentialFormState();
}

class _CreateCredentialFormState extends State<CreateCredentialForm> {
  final _key = GlobalKey<FormState>();

  String _secretName = "";
  String _username = "";
  String _password = "";

  bool get _canSubmitForm {
    return _secretName.trim().isNotEmpty &&
        _username.trim().isNotEmpty &&
        _password.trim().isNotEmpty;
  }

  void _onSubmitAction() async {
    if (_key.currentState!.validate()) {
      await BlocProvider.of<CredentialCreateCubit>(context).createCredential(
        widget.vaultId,
        _secretName,
        SecretType.credential,
        _username,
        _password,
      );
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  void _credentialCreateCubitListener(ctx, state) async {
    if (state is CredentialCreateError) {
      await PasswordlyAlertDialog.show(
        "Error",
        state.message,
        ctx,
      );
      if (ctx.mounted) {
        BlocProvider.of<CredentialCreateCubit>(ctx).resetState();
      }
    } else if (state is CredentialCreateSuccess) {
      PasswordlyScaffoldMessenger.showSnackBar(ctx, "Added credential.");
      Navigator.pop(ctx);
    }
  }

  Widget _credentialCreateCubitBuilder(ctx, state) {
    if (state is CredentialCreateLoading) {
      return const PasswordlyDefaultDialog(
        height: 400,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is CredentialCreateInitial) {
      return PasswordlyDefaultDialog(
        height: 400,
        child: Form(
          key: _key,
          child: Column(
            children: [
              Text(
                "Create Credential",
                style: Theme.of(ctx).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  return (value?.trim() ?? "").isEmpty
                      ? "Enter a valid name"
                      : null;
                },
                onChanged: (newValue) {
                  setState(() {
                    _secretName = newValue;
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Username")),
                validator: (value) {
                  return (value?.trim() ?? "").isEmpty
                      ? "Enter a valid value"
                      : null;
                },
                onChanged: (newValue) {
                  setState(() {
                    _username = newValue;
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Password")),
                validator: (value) {
                  return (value?.trim() ?? "").isEmpty
                      ? "Enter a valid value"
                      : null;
                },
                onChanged: (newValue) {
                  setState(() {
                    _password = newValue;
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx, rootNavigator: true).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: _canSubmitForm ? _onSubmitAction : null,
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return const PasswordlyDefaultDialog(height: 400);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        child: BlocConsumer<CredentialCreateCubit, CredentialCreateState>(
          builder: _credentialCreateCubitBuilder,
          listener: _credentialCreateCubitListener,
        ),
      ),
    );
  }
}

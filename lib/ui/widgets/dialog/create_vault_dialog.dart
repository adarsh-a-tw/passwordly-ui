import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/data/repositories/vault_repository.dart';
import 'package:passwordly/logic/cubit/vault_create_cubit.dart';
import 'package:passwordly/networking/service/passwordly_api_service_provider.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_alert_dialog.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_default_dialog.dart';
import 'package:passwordly/utils/passwordly_scaffold_messenger.dart';

class CreateVaultDialog extends StatefulWidget {
  const CreateVaultDialog({super.key});

  @override
  State<CreateVaultDialog> createState() => _CreateVaultDialogState();
}

class _CreateVaultDialogState extends State<CreateVaultDialog> {
  final _controller = TextEditingController();
  String _vaultName = "My new vault";
  String? _errorMessage;

  @override
  void initState() {
    _controller.text = _vaultName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = VaultCreateCubit(
      VaultRepository(
        PasswordlyApiServiceProvider.service,
      ),
    );
    return BlocConsumer<VaultCreateCubit, VaultCreateState>(
      bloc: cubit,
      listener: (context, state) async {
        if (state is VaultCreateSuccess && Navigator.canPop(context)) {
          PasswordlyScaffoldMessenger.showSnackBar(
            context,
            "$_vaultName created successfully.",
          );
          Navigator.pop(context);
        } else if (state is VaultCreateError) {
          await PasswordlyAlertDialog.show("Error", state.message, context);
          if (context.mounted) {
            cubit.resetState();
          }
        }
      },
      builder: (context, state) {
        if (state is VaultCreateLoading) {
          return const PasswordlyDefaultDialog(
            height: 280,
            child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
              ),
            ),
          );
        }

        if (state is VaultCreateInitial) {
          return PasswordlyDefaultDialog(
            height: 280.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter Vault name",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 32,
                ),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    errorText: _errorMessage,
                  ),
                  autofocus: true,
                  onChanged: (value) => {
                    setState(
                      () {
                        _vaultName = value;
                        _errorMessage = _vaultName.trim().isEmpty
                            ? "Enter a valid name"
                            : null;
                      },
                    )
                  },
                ),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onPressed: _errorMessage == null
                          ? () {
                              cubit.createVault(_vaultName);
                            }
                          : null,
                      child: const Text("Save"),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    )
                  ],
                )
              ],
            ),
          );
        }

        return const PasswordlyDefaultDialog(
          height: 280,
        );
      },
    );
  }
}

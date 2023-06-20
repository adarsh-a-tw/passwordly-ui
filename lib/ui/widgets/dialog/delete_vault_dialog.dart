import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/data/repositories/vault_repository.dart';
import 'package:passwordly/logic/cubit/vault_delete_cubit.dart';
import 'package:passwordly/networking/service/passwordly_api_service_provider.dart';
import 'package:passwordly/ui/routes/route_argument_key.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_alert_dialog.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_default_dialog.dart';
import 'package:passwordly/ui/widgets/passwordly_navigator.dart';
import 'package:passwordly/utils/passwordly_scaffold_messenger.dart';

class DeleteVaultDialog extends StatelessWidget {
  final String vaultId;
  final String vaultName;

  const DeleteVaultDialog({
    super.key,
    required this.vaultId,
    required this.vaultName,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = VaultDeleteCubit(
      VaultRepository(
        PasswordlyApiServiceProvider.service,
      ),
    );
    return BlocConsumer<VaultDeleteCubit, VaultDeleteState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is VaultDeleteSuccess && Navigator.canPop(context)) {
          PasswordlyScaffoldMessenger.showSnackBar(
            context,
            "$vaultName deleted successfully.",
          );
          PasswordlyNavigator.pushNamedAndRemoveUntilWithArguments(
            context,
            "/home",
            (route) => false,
            arguments: {RouteArgumentKey.shouldSlideLeft: true},
          );
        } else if (state is VaultDeleteError) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          PasswordlyAlertDialog.show("Error", state.message, context);
        }
      },
      builder: (context, state) {
        if (state is VaultDeleteLoading) {
          return const PasswordlyDefaultDialog(
            height: 260.0,
            child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
              ),
            ),
          );
        }

        if (state is VaultDeleteInitial) {
          return PasswordlyDefaultDialog(
            height: 260.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 104,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Are you sure ?",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        cubit.deleteVault(vaultId);
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
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
          height: 260.0,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/logic/cubit/vault_detail_cubit.dart';
import 'package:passwordly/ui/widgets/dialog/choose_secret_type_dialog.dart';
import 'package:passwordly/ui/widgets/dialog/delete_vault_dialog.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_alert_dialog.dart';
import 'package:passwordly/ui/widgets/generic_error_message.dart';
import 'package:passwordly/ui/widgets/list_views/secret_list_view.dart';
import 'package:passwordly/ui/widgets/scaffold/passwordly_scaffold.dart';

class VaultDetailsScreen extends StatelessWidget {
  final String vaultId;
  final String vaultName;

  const VaultDetailsScreen(
      {super.key, required this.vaultId, required this.vaultName});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<VaultDetailCubit>(context);
    cubit.fetchVaultDetails(vaultId);
    return PasswordlyScaffold(
      appBar: AppBar(
        title: Text(vaultName),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (ctx) {
                  return Dialog(
                    elevation: 0,
                    backgroundColor: const Color(0x00ffffff),
                    // child: SizedBox(
                    //   height: 320,
                    child: ChooseSecretTypeDialog(
                      vaultId: vaultId,
                    ),
                    // ),
                  );
                },
              );
              cubit.fetchVaultDetails(vaultId);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => Dialog(
                  child: DeleteVaultDialog(
                    vaultId: vaultId,
                    vaultName: vaultName,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          cubit.fetchVaultDetails(vaultId);
        },
        child: BlocConsumer<VaultDetailCubit, VaultDetailState>(
          bloc: cubit,
          listener: (context, state) async {
            if (state is VaultDetailError) {
              await PasswordlyAlertDialog.show(
                "Error",
                state.message,
                context,
                buttonText: "Retry",
              );
              cubit.fetchVaultDetails(vaultId);
            }
          },
          builder: (context, state) {
            if (state is VaultDetailLoading) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "We are fetching your secrets, please wait.",
                      style: Theme.of(context).textTheme.bodyLarge!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (state is VaultDetailSuccess) {
              return SecretListView(secrets: state.vault.secrets);
            } else if (state is VaultDetailError) {
              return Column();
            } else {
              return const GenericErrorMessage();
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/logic/cubit/vault_detail_cubit.dart';
import 'package:passwordly/ui/widgets/dialog/delete_vault_dialog.dart';
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
              onPressed: () async {},
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
        body: Column());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/logic/cubit/vault_detail_cubit.dart';
import 'package:passwordly/ui/widgets/dialog/choose_secret_type_dialog.dart';
import 'package:passwordly/ui/widgets/dialog/delete_vault_dialog.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_alert_dialog.dart';
import 'package:passwordly/ui/widgets/generic_error_message.dart';
import 'package:passwordly/ui/widgets/list_views/secret_list_view.dart';
import 'package:passwordly/ui/widgets/scaffold/passwordly_scaffold.dart';

class VaultDetailsScreen extends StatefulWidget {
  final String vaultId;
  final String vaultName;

  const VaultDetailsScreen({
    super.key,
    required this.vaultId,
    required this.vaultName,
  });

  @override
  State<VaultDetailsScreen> createState() => _VaultDetailsScreenState();
}

class _VaultDetailsScreenState extends State<VaultDetailsScreen> {
  void _fetchVaultDetails() {
    BlocProvider.of<VaultDetailCubit>(context)
        .fetchVaultDetails(widget.vaultId);
  }

  void _createSecretAction() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          elevation: 0,
          backgroundColor: const Color(0x00ffffff),
          child: ChooseSecretTypeDialog(
            vaultId: widget.vaultId,
          ),
        );
      },
    );
    _fetchVaultDetails();
  }

  void _deleteVaultAction() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: DeleteVaultDialog(
          vaultId: widget.vaultId,
          vaultName: widget.vaultName,
        ),
      ),
    );
  }

  void _vaultDetailCubitListener(context, state) async {
    if (state is VaultDetailError) {
      await PasswordlyAlertDialog.show(
        "Error",
        state.message,
        context,
        buttonText: "Retry",
      );
      _fetchVaultDetails();
    }
  }

  Widget _vaultDetailCubitBuilder(context, state) {
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
  }

  @override
  void initState() {
    _fetchVaultDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PasswordlyScaffold(
      appBar: AppBar(
        title: Text(widget.vaultName),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
            onPressed: _createSecretAction,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: _deleteVaultAction,
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchVaultDetails();
        },
        child: BlocConsumer<VaultDetailCubit, VaultDetailState>(
          listener: _vaultDetailCubitListener,
          builder: _vaultDetailCubitBuilder,
        ),
      ),
    );
  }
}

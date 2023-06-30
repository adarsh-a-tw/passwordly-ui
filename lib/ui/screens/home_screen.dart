import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/logic/bloc/auth_bloc.dart';
import 'package:passwordly/logic/cubit/vault_list_cubit.dart';
import 'package:passwordly/ui/widgets/dialog/create_vault_dialog.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_alert_dialog.dart';
import 'package:passwordly/ui/widgets/drawer/passwordly_drawer.dart';
import 'package:passwordly/ui/widgets/generic_error_message.dart';
import 'package:passwordly/ui/widgets/list_views/vault_list_view.dart';
import 'package:passwordly/ui/widgets/scaffold/passwordly_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _fetchVaults();
    super.initState();
  }

  void _fetchVaults() => BlocProvider.of<VaultListCubit>(context).fetchVaults();

  void _addVaultAction() async {
    await showDialog(
      context: context,
      builder: (_) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: CreateVaultDialog(),
        );
      },
    );
    _fetchVaults();
  }

  void _vaultListCubitListener(context, state) async {
    if (state is VaultListError) {
      await PasswordlyAlertDialog.show(
        "Error",
        state.message,
        context,
        buttonText: "Retry",
      );
      _fetchVaults();
    }
  }

  Widget _authBlocBuilder(context, state) {
    if (state is Authenticated) {
      return BlocConsumer<VaultListCubit, VaultListState>(
        listener: _vaultListCubitListener,
        builder: _vaultListCubitBuilder,
      );
    }

    return const GenericErrorMessage();
  }

  Widget _vaultListCubitBuilder(context, state) {
    if (state is VaultListLoading) {
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
              "We are fetching your vaults, please wait.",
              style: Theme.of(context).textTheme.bodyLarge!,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (state is VaultListSuccess) {
      return VaultListView(vaults: state.vaults);
    } else if (state is VaultListError) {
      return Column();
    } else {
      return const GenericErrorMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PasswordlyScaffold(
      appBar: AppBar(
        title: const Text("My Vaults"),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
            onPressed: _addVaultAction,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const PasswordlyDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchVaults();
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: _authBlocBuilder,
        ),
      ),
    );
  }
}

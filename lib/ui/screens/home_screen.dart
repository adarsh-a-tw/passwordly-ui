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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<VaultListCubit>(context);
    cubit.fetchVaults();
    return PasswordlyScaffold(
      appBar: AppBar(
        title: const Text("My Vaults"),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (ctx) {
                  return const Dialog(
                    backgroundColor: Colors.transparent,
                    child: CreateVaultDialog(),
                  );
                },
              );
              cubit.fetchVaults();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const PasswordlyDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          cubit.fetchVaults();
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return BlocConsumer<VaultListCubit, VaultListState>(
                  listener: (context, state) async {
                if (state is VaultListError) {
                  await PasswordlyAlertDialog.show(
                    "Error",
                    state.message,
                    context,
                    buttonText: "Retry",
                  );
                  cubit.fetchVaults();
                }
              }, builder: (context, state) {
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
              });
            }

            return const GenericErrorMessage();
          },
        ),
      ),
    );
  }
}

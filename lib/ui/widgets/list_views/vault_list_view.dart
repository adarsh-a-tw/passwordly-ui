import 'package:flutter/material.dart';
import 'package:passwordly/data/models/vault.dart';
import 'package:passwordly/ui/routes/route_argument_key.dart';
import 'package:passwordly/utils/extended_date_format.dart';
import 'package:passwordly/ui/widgets/passwordly_navigator.dart';

class VaultListView extends StatelessWidget {
  final List<Vault> vaults;

  const VaultListView({super.key, required this.vaults});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final vault = vaults[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: () => {
                    PasswordlyNavigator.pushNamedWithArguments(
                      context,
                      "/vault",
                      arguments: {
                        RouteArgumentKey.vaultId: vault.id,
                        RouteArgumentKey.vaultName: vault.name,
                      },
                    )
                  },
                  child: Card(
                    key: ValueKey(vault.id),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                vault.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Text(
                                "Last updated at ${ExtendedDateFormat.formattedDate(vault.updatedAt)}",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            childCount: vaults.length,
          ),
        )
      ],
    );
  }
}

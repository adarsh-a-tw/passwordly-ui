import 'package:flutter/material.dart';
import 'package:passwordly/data/models/vault.dart';
import 'package:passwordly/ui/routes/route_argument_key.dart';
import 'package:passwordly/ui/widgets/passwordly_navigator.dart';
import 'package:passwordly/utils/extended_date_format.dart';

class VaultListItem extends StatelessWidget {
  final Vault vault;

  const VaultListItem({super.key, required this.vault});

  void _onTapAction(BuildContext context) {
    PasswordlyNavigator.pushNamedWithArguments(
      context,
      "/vault",
      arguments: {
        RouteArgumentKey.vaultId: vault.id,
        RouteArgumentKey.vaultName: vault.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          _onTapAction(context);
        },
        borderRadius: BorderRadius.circular(16.0),
        splashColor: Theme.of(context).colorScheme.onSecondaryContainer,
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
  }
}

import 'package:flutter/material.dart';
import 'package:passwordly/data/models/vault.dart';
import 'package:passwordly/ui/widgets/generic_info_message_view.dart';
import 'package:passwordly/ui/widgets/list_item_views/vault_list_item.dart';

class VaultListView extends StatelessWidget {
  final List<Vault> vaults;

  const VaultListView({super.key, required this.vaults});

  @override
  Widget build(BuildContext context) {
    if (vaults.isEmpty) {
      return const GenericInfoMessageView(
          message: "No vaults found. Create one.");
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => VaultListItem(vault: vaults[index]),
            childCount: vaults.length,
          ),
        )
      ],
    );
  }
}

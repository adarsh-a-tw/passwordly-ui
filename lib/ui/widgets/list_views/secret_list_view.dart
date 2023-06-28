import 'package:flutter/widgets.dart';
import 'package:passwordly/data/models/secret.dart';
import 'package:passwordly/ui/widgets/generic_info_message_view.dart';
import 'package:passwordly/ui/widgets/list_item_views/secret_list_item.dart';

class SecretListView extends StatelessWidget {
  final List<Secret> secrets;

  const SecretListView({
    super.key,
    required this.secrets,
  });

  @override
  Widget build(BuildContext context) {
    if (secrets.isEmpty) {
      return const GenericInfoMessageView(
          message: "No secrets found. Create one.");
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: SecretListItem(secret: secrets[index]),
            ),
            childCount: secrets.length,
          ),
        )
      ],
    );
  }
}

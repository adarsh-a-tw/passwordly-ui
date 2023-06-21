import 'package:flutter/material.dart';
import 'package:passwordly/data/models/secret.dart';
import 'package:passwordly/utils/extended_date_format.dart';

class SecretListItem extends StatelessWidget {
  final Secret secret;

  const SecretListItem({super.key, required this.secret});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        key: ValueKey(secret.id),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    secret.name,
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
                    "Last updated at ${ExtendedDateFormat.formattedDate(secret.updatedAt)}",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

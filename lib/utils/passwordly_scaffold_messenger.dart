import 'package:flutter/material.dart';

class PasswordlyScaffoldMessenger {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: Row(
            children: [
              Icon(
                Icons.info,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
            ],
          )),
    );
  }
}

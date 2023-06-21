import 'package:flutter/material.dart';

class GenericInfoMessageView extends StatelessWidget {
  final String message;

  const GenericInfoMessageView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info,
            size: 64,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ],
      ),
    );
  }
}

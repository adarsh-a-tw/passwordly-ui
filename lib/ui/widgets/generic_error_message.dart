import 'package:flutter/material.dart';

class GenericErrorMessage extends StatelessWidget {
  const GenericErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 104,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "App in Invalid State",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            "Relaunch the app & try again!",
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}

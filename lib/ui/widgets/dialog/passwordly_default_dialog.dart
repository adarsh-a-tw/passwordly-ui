import 'package:flutter/material.dart';

class PasswordlyDefaultDialog extends StatelessWidget {
  final Widget? child;
  final double height;

  const PasswordlyDefaultDialog({super.key, this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: child,
    );
  }
}

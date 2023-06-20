import 'package:flutter/material.dart';

class PasswordlyScaffold extends StatelessWidget {
  const PasswordlyScaffold({
    super.key,
    this.appBarTitle,
    this.appBar,
    this.drawer,
    this.padding = const EdgeInsets.all(16.0),
    required this.body,
  });

  final String? appBarTitle;
  final AppBar? appBar;
  final Widget? drawer;
  final Widget body;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: appBar == null && appBarTitle == null
          ? null
          : appBar ??
              AppBar(
                title: Text(appBarTitle!),
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
      body: SafeArea(
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0.0),
          child: body,
        ),
      ),
    );
  }
}

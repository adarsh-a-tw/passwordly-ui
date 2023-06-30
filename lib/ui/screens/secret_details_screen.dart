import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:passwordly/data/models/secret.dart';
import 'package:passwordly/ui/widgets/scaffold/passwordly_scaffold.dart';
import 'package:passwordly/ui/widgets/secret_display_view.dart';

class SecretDetailsScreen extends StatelessWidget {
  final Secret secret;
  const SecretDetailsScreen({super.key, required this.secret});

  @override
  Widget build(BuildContext context) {
    final cred = secret.entity as Credential;
    return PasswordlyScaffold(
      appBarTitle: secret.name,
      body: Column(
        children: [
          SecretDisplayView(title: "Username", text: cred.username),
          const SizedBox(
            height: 16,
          ),
          SecretDisplayView(
            title: "Password",
            text: cred.password,
            needsSecurity: true,
          ),
        ],
      ),
    );
  }
}

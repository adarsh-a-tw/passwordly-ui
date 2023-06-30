import 'package:flutter/material.dart';
import 'package:passwordly/data/models/secret.dart';
import 'package:passwordly/ui/routes/route_argument_key.dart';
import 'package:passwordly/ui/widgets/dialog/create_secret_dialog.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_default_dialog.dart';
import 'package:passwordly/ui/widgets/passwordly_navigator.dart';

class ChooseSecretTypeDialog extends StatefulWidget {
  final String vaultId;

  const ChooseSecretTypeDialog({super.key, required this.vaultId});

  @override
  State<ChooseSecretTypeDialog> createState() => _ChooseSecretTypeDialogState();
}

class _ChooseSecretTypeDialogState extends State<ChooseSecretTypeDialog> {
  void _onSelect(BuildContext context, SecretType type) {
    PasswordlyNavigator.pushNamedWithArguments(
      context,
      "/create",
      arguments: {RouteArgumentKey.secretType: type},
    );
  }

  Route<dynamic>? _nestedNavigatorOnGenerateRoutes(settings) {
    switch (settings.name) {
      case "/create":
        return MaterialPageRoute(
          builder: (ctx) => CreateSecretDialog(
            type: (settings.arguments
                as Map<RouteArgumentKey, dynamic>)[RouteArgumentKey.secretType],
            vaultId: widget.vaultId,
          ),
        );
      default:
        return MaterialPageRoute(builder: (ctx) {
          return Center(
            child: SizedBox(
              height: 248,
              child: PasswordlyDefaultDialog(
                height: 248,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "What do you want to add?",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      height: 90,
                      width: double.infinity,
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _SecretTypeGridItem(
                            iconData: Icons.lock,
                            name: "Credential",
                            onPressed: () {
                              _onSelect(ctx, SecretType.credential);
                            },
                          ),
                          const _SecretTypeGridItem(
                            iconData: Icons.key,
                            name: "Key",
                            onPressed: null,
                          ),
                          const _SecretTypeGridItem(
                            iconData: Icons.edit_document,
                            name: "Document",
                            onPressed: null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "/",
      onGenerateRoute: _nestedNavigatorOnGenerateRoutes,
    );
  }
}

class _SecretTypeGridItem extends StatelessWidget {
  final IconData iconData;
  final String name;
  final Function()? onPressed;

  const _SecretTypeGridItem({
    required this.iconData,
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed != null ? 1.0 : 0.5,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.white),
          ),
          child: Ink(
            width: 100,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(iconData),
                Text(name),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

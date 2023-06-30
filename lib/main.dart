import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/data/repositories/repository_provider.dart';
import 'package:passwordly/logic/bloc/auth_bloc.dart';
import 'package:passwordly/networking/api_client/passwordly_api_client.dart';
import 'package:passwordly/networking/api_client/passwordly_api_client_provider.dart';
import 'package:passwordly/ui/routes/route_argument_key.dart';
import 'package:passwordly/ui/routes/router.dart';

void main() {
  final client = PasswordlyApiClientProvider.client;
  final repositoryProvider = PasswordlyRepositoryProvider();

  repositoryProvider.configure(client);

  runApp(
    PasswordlyApp(
      PasswordlyRouter(repositoryProvider),
      client,
    ),
  );
}

class PasswordlyApp extends StatefulWidget {
  final PasswordlyRouter _router;
  final PasswordlyApiClient _client;

  const PasswordlyApp(this._router, this._client, {super.key});

  @override
  State<PasswordlyApp> createState() => _PasswordlyAppState();
}

class _PasswordlyAppState extends State<PasswordlyApp> {
  final _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    widget._client.registerSessionExpiryCallback(() {
      _navKey.currentState!.pushNamedAndRemoveUntil(
        "/login",
        (route) => false,
        arguments: {
          RouteArgumentKey.didSessionExpire: true,
          RouteArgumentKey.shouldSlideLeft: true,
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => AuthBloc(
            PasswordlyRepositoryProvider().authRepository,
            PasswordlyRepositoryProvider().userRepository,
          )),
      child: MaterialApp(
        navigatorKey: _navKey,
        title: 'Passwordly',
        theme: ThemeData.dark(useMaterial3: true),
        onGenerateRoute: widget._router.onGenerateRoute,
      ),
    );
  }
}

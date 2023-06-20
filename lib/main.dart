import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/logic/bloc/auth_bloc.dart';
import 'package:passwordly/data/repositories/auth_repository.dart';
import 'package:passwordly/networking/service/passwordly_api_service.dart';
import 'package:passwordly/networking/service/passwordly_api_service_provider.dart';
import 'package:passwordly/ui/routes/route_argument_key.dart';
import 'package:passwordly/ui/routes/router.dart';

void main() {
  final service = PasswordlyApiServiceProvider.service;
  runApp(
    PasswordlyApp(
      router: PasswordlyRouter(service),
      service: service,
    ),
  );
}

class PasswordlyApp extends StatefulWidget {
  final PasswordlyRouter router;
  final PasswordlyApiService service;

  const PasswordlyApp({super.key, required this.router, required this.service});

  @override
  State<PasswordlyApp> createState() => _PasswordlyAppState();
}

class _PasswordlyAppState extends State<PasswordlyApp> {
  final _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    widget.service.registerSessionExpiryCallback(() {
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
            AuthRepository(
              widget.service,
            ),
          )),
      child: MaterialApp(
        navigatorKey: _navKey,
        title: 'Passwordly',
        theme: ThemeData.dark(useMaterial3: true),
        onGenerateRoute: widget.router.onGenerateRoute,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/data/repositories/vault_repository.dart';
import 'package:passwordly/logic/cubit/vault_create_cubit.dart';
import 'package:passwordly/logic/cubit/vault_detail_cubit.dart';
import 'package:passwordly/logic/cubit/vault_list_cubit.dart';
import 'package:passwordly/networking/service/passwordly_api_service.dart';
import 'package:passwordly/ui/routes/route_argument_key.dart';
import 'package:passwordly/ui/screens/home_screen.dart';
import 'package:passwordly/ui/screens/landing_screen.dart';
import 'package:passwordly/ui/screens/login_screen.dart';
import 'package:passwordly/ui/screens/vault_details_screen.dart';
import 'package:passwordly/utils/route_argument_map.dart';

class PasswordlyRouter {
  final PasswordlyApiService service;

  PasswordlyRouter(this.service);

  Route onGenerateRoute(RouteSettings settings) {
    final Map<RouteArgumentKey, dynamic> arguments = settings.arguments != null
        ? (settings.arguments as Map<RouteArgumentKey, dynamic>)
        : {};
    final Widget widget;
    switch (settings.name) {
      case "/":
        widget = const LandingScreen();
        break;
      case "/home":
        widget = _homeWidget;
        break;
      case "/login":
        final bool didSessionExpire =
            arguments.find(RouteArgumentKey.didSessionExpire, false);
        widget = _generateLoginWidget(didSessionExpire);
        break;
      case "/vault":
        final String vaultId = arguments.find(RouteArgumentKey.vaultId, "");
        final String vaultName = arguments.find(RouteArgumentKey.vaultName, "");
        widget = _generateVaultDetailWidget(vaultId, vaultName);
        break;
      default:
        widget = const LandingScreen();
    }
    final bool shouldSlideLeft = arguments.find(
      RouteArgumentKey.shouldSlideLeft,
      false,
    );
    return _generateRoute(widget, shouldSlideLeft);
  }

  Route _generateRoute(Widget widget, bool shouldSlideLeft) {
    if (shouldSlideLeft) {
      return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          });
    }

    return MaterialPageRoute(builder: ((context) => widget));
  }

  Widget get _homeWidget {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VaultListCubit>(
          create: (context) => VaultListCubit(
            VaultRepository(service),
          ),
        ),
        BlocProvider<VaultCreateCubit>(
          create: (context) => VaultCreateCubit(
            VaultRepository(service),
          ),
        ),
      ],
      child: const HomeScreen(),
    );
  }

  Widget _generateLoginWidget(bool didSessionExpire) {
    return LoginScreen(
      showSessionExpiredMessage: didSessionExpire,
    );
  }

  Widget _generateVaultDetailWidget(String vaultId, String vaultName) {
    return BlocProvider<VaultDetailCubit>(
      create: (ctx) => VaultDetailCubit(
        VaultRepository(service),
      ),
      child: VaultDetailsScreen(
        vaultName: vaultName,
        vaultId: vaultId,
      ),
    );
  }
}

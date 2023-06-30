import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/logic/bloc/auth_bloc.dart';
import 'package:passwordly/ui/routes/route_argument_key.dart';
import 'package:passwordly/ui/widgets/passwordly_navigator.dart';

class PasswordlyDrawer extends StatelessWidget {
  const PasswordlyDrawer({super.key});

  void _logoutAction(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).authRepository.logout();
    PasswordlyNavigator.pushNamedAndRemoveUntilWithArguments(
      context,
      "/login",
      (route) => false,
      arguments: {RouteArgumentKey.shouldSlideLeft: true},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: ListView(
            children: [
              SizedBox(
                height: 72.0,
                child: DrawerHeader(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Passwordly",
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "Signed in as ${state is Authenticated ? state.user.username : "user"}",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
                onTap: () {
                  _logoutAction(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

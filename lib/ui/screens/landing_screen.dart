import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/logic/cubit/version_info_cubit.dart';
import 'package:passwordly/ui/widgets/buttons/primary_button.dart';
import 'package:passwordly/ui/widgets/scaffold/passwordly_scaffold.dart';
import 'package:passwordly/ui/widgets/passwordly_navigator.dart';
import 'package:passwordly/utils/github_release_tracker.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PasswordlyScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Passwordly",
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "A secure place to store your passwords.",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 60,
            ),
            BlocProvider<VersionInfoCubit>.value(
              value: VersionInfoCubit(GithubReleaseTracker()),
              child: SizedBox(
                height: 240,
                width: double.infinity,
                child: _LandingActions(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LandingActions extends StatefulWidget {
  @override
  State<_LandingActions> createState() => _LandingActionsState();
}

class _LandingActionsState extends State<_LandingActions> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<VersionInfoCubit>(context).getVersionInfo();
  }

  List<Widget> _loginAndSignup() {
    return [
      PrimaryButton(
        title: "Login",
        onPressed: () => PasswordlyNavigator.pushNamedWithArguments(
          context,
          "/login",
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      ElevatedButton(
        onPressed: () => PasswordlyNavigator.pushNamedWithArguments(
          context,
          "/signup",
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: Text(
            "Register",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VersionInfoCubit, VersionInfoState>(
      builder: (ctx, state) {
        if (state is VersionInfoLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is VersionInfoError) {
          return Column(children: [
            ..._loginAndSignup(),
            const SizedBox(
              height: 20,
            ),
            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ]);
        }
        if (state is VersionInfoSuccess) {
          if (state.shouldUpdate) {
            return Column(
              children: [
                const Text("Please update the app to proceed further"),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0)),
                  child: Text(
                    "Update",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            );
          }
          return Column(
            children: [
              ..._loginAndSignup(),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0)),
                child: Text(
                  "Update",
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                state.currentVersion.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          );
        }
        return const Column();
      },
    );
  }
}

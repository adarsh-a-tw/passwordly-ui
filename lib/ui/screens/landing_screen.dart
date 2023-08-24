import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/data/models/device_info.dart';
import 'package:passwordly/data/models/version.dart';
import 'package:passwordly/logic/cubit/device_info_cubit.dart';
import 'package:passwordly/logic/cubit/version_info_cubit.dart';
import 'package:passwordly/ui/widgets/buttons/primary_button.dart';
import 'package:passwordly/ui/widgets/scaffold/passwordly_scaffold.dart';
import 'package:passwordly/ui/widgets/passwordly_navigator.dart';
import 'package:passwordly/utils/environment.dart';
import 'package:passwordly/utils/github_release_tracker.dart';
import 'package:url_launcher/url_launcher.dart';

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
            MultiBlocProvider(
              providers: [
                BlocProvider<VersionInfoCubit>.value(
                  value: VersionInfoCubit(GithubReleaseTracker()),
                ),
                BlocProvider<DeviceInfoCubit>.value(
                  value: DeviceInfoCubit(),
                ),
              ],
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
    BlocProvider.of<DeviceInfoCubit>(context).getDeviceInfo();
  }

  _launchURLBrowser(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  List<Widget> get _loginAndSignup {
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

  Widget get iosDeviceActions {
    return Column(children: _loginAndSignup);
  }

  Widget androidDeviceDefaultActions(Version currentVersion) {
    return Column(children: [
      ..._loginAndSignup,
      const SizedBox(
        height: 20,
      ),
      Text(
        "Installed version: ${currentVersion.toString()}",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ]);
  }

  Widget androidDeviceActionsWhenVersionFetchFails(String message) {
    return Column(children: [
      ..._loginAndSignup,
      const SizedBox(
        height: 20,
      ),
      Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ]);
  }

  Widget androidDeviceActionsWhenForceUpdateNeeded(Uri url) {
    return Column(
      children: [
        const Text("Please update the app to proceed further"),
        const SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () async {
            await _launchURLBrowser(url);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
          ),
          child: Text(
            "Download latest update",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget androidDeviceActionsWhenDefaultUpdatesAvailable(
      Version currentVersion, Uri url) {
    return Column(
      children: [
        ..._loginAndSignup,
        const SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () async {
            await _launchURLBrowser(url);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
          ),
          child: Text(
            "Download latest update",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Installed version: ${currentVersion.toString()}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceInfoCubit, DeviceInfoState>(
        builder: (devInfoCtx, devInfoState) {
      return BlocBuilder<VersionInfoCubit, VersionInfoState>(
        builder: (versionInfoCtx, versionInfoState) {
          if (devInfoState is DeviceInfoLoading ||
              versionInfoState is VersionInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (devInfoState is DeviceInfoSuccess) {
            if (devInfoState.deviceInfo is IosDeviceInfo) {
              return iosDeviceActions;
            } else {
              String abi = (devInfoState.deviceInfo as AndroidDeviceInfo).abi;
              if (versionInfoState is VersionInfoError) {
                return androidDeviceActionsWhenVersionFetchFails(
                  versionInfoState.message,
                );
              }

              if (versionInfoState is VersionInfoSuccess) {
                Uri url = Uri.https(
                  "github.com",
                  "${Environment().kGithubRepo}/releases/download/${versionInfoState.latestVersion.toString()}/app-$abi-release.apk",
                );
                if (versionInfoState.shouldUpdate) {
                  return androidDeviceActionsWhenForceUpdateNeeded(url);
                }

                if (versionInfoState.canUpdate) {
                  return androidDeviceActionsWhenDefaultUpdatesAvailable(
                    versionInfoState.currentVersion,
                    url,
                  );
                }

                return androidDeviceDefaultActions(
                  versionInfoState.currentVersion,
                );
              }
            }
          }
          return const Column();
        },
      );
    });
  }
}

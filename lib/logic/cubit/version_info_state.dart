part of 'version_info_cubit.dart';

@immutable
abstract class VersionInfoState {}

class VersionInfoLoading extends VersionInfoState {}

class VersionInfoError extends VersionInfoState {
  final String message;

  VersionInfoError(this.message);
}

class VersionInfoSuccess extends VersionInfoState {
  final Version currentVersion;
  final Version latestVersion;
  final bool canUpdate;
  final bool shouldUpdate;

  VersionInfoSuccess(this.currentVersion, this.latestVersion, this.canUpdate,
      this.shouldUpdate);
}

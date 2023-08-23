import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/utils/github_release_tracker.dart';

import '../../data/models/version.dart';
import 'package:meta/meta.dart';

part 'version_info_state.dart';

class VersionInfoCubit extends Cubit<VersionInfoState> {
  final GithubReleaseTracker _releaseTracker;
  VersionInfoCubit(this._releaseTracker) : super(VersionInfoLoading());

  Future<void> getVersionInfo() async {
    try {
      final latestVersion = await _releaseTracker.latestVersion();
      final currentVersion = await Version.fromRuntime();

      emit(VersionInfoSuccess(
        currentVersion,
        latestVersion,
        _canUpdate(latestVersion, currentVersion),
        _isForceUpdateRequired(latestVersion, currentVersion),
      ));

    } catch (_) {
      emit(VersionInfoError("Error fetching version info"));
    }
  }

  bool _isForceUpdateRequired(Version latestVersion, Version currentVersion) {
    return currentVersion.major < latestVersion.major;
  }

  bool _canUpdate(Version latestVersion, Version currentVersion) {
    return currentVersion != latestVersion;
  }
}

import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Version extends Equatable {
  final int major;
  final int minor;
  final int patch;

  const Version(this.major, this.minor, this.patch);

  static Future<Version> fromRuntime() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return Version.fromString(packageInfo.version);
  }

  factory Version.fromString(String version) {
    final parts = version.split(".").map((e) => int.parse(e)).toList();
    return Version(parts[0], parts[1], parts[2]);
  }

  @override
  String toString() {
    return "v$major.$minor.$patch";
  }

  @override
  List<Object?> get props => [major, minor, patch];
}

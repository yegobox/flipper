import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// What this binary is, as CI stamped it at build time.
///
/// pubspec's `version:` is not the version people see: the Store build gets
/// its msix version from `scripts/ci/msix_version.sh` (e.g. `1.605.0.0`, the
/// `v1.605.0.0_windows_prod` release), and that number never reaches the Dart
/// side unless CI passes it in. Without it nobody can tell which release a
/// till is running, so CI passes:
///
/// * `--dart-define=FLIPPER_RELEASE_VERSION=<msix version>` on Store builds;
/// * `--dart-define=FLIPPER_RELEASE_COMMIT=<git sha>` on every release build,
///   so a launcher build (whose version is only assigned after it is built)
///   can still be matched to the commit a release points at.
class AppBuildInfo {
  const AppBuildInfo._();

  static const String releaseVersion = String.fromEnvironment(
    'FLIPPER_RELEASE_VERSION',
  );
  static const String releaseCommit = String.fromEnvironment(
    'FLIPPER_RELEASE_COMMIT',
  );

  /// The label shown under the startup progress bar, e.g.
  /// `v1.605.0.0 · 0a9a65f`. Falls back to the pubspec version for local
  /// builds, and to null when even that cannot be read.
  static Future<String?> label() => labelFor(
    version: releaseVersion,
    commit: releaseCommit,
    pubspecVersion: _pubspecVersion,
  );

  static Future<String> _pubspecVersion() async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version}+${info.buildNumber}';
  }

  @visibleForTesting
  static Future<String?> labelFor({
    required String version,
    required String commit,
    required Future<String> Function() pubspecVersion,
  }) async {
    final sha = commit.length > 7 ? commit.substring(0, 7) : commit;
    if (version.isNotEmpty) {
      return sha.isEmpty ? 'v$version' : 'v$version · $sha';
    }
    // A release build without a version (the launcher's): pubspec's number
    // would only mislead, so the commit is the whole answer.
    if (sha.isNotEmpty) return 'build $sha';
    try {
      return 'v${await pubspecVersion()} · dev';
    } catch (_) {
      return null;
    }
  }
}

import 'package:flutter/foundation.dart';

/// Atlas, the Flipper launcher (github.com/yegobox/flipper-launcher): it
/// installs Flipper on a computer and keeps it and itself up to date.
///
/// The file names are the launcher README's contract:
/// `releases/latest/download/<name>` always serves the newest release.
abstract final class AtlasDownloads {
  static const _latest =
      'https://github.com/yegobox/flipper-launcher/releases/latest/download';

  static const windows = '$_latest/Atlas-Windows-x64-setup.exe';
  static const macOS = '$_latest/Atlas-macOS.dmg';
  static const linuxAppImage = '$_latest/Atlas-Linux-x86_64.AppImage';
  static const linuxDeb = '$_latest/Atlas-Linux-amd64.deb';
  static const releases =
      'https://github.com/yegobox/flipper-launcher/releases';
}

/// A computer Atlas ships for.
enum AtlasPlatform {
  windows('Windows', AtlasDownloads.windows),
  macOS('macOS', AtlasDownloads.macOS),
  linux('Linux', AtlasDownloads.linuxAppImage);

  const AtlasPlatform(this.label, this.url);

  final String label;

  /// The installer to offer first.
  final String url;

  /// The computer the page is open on — on the web, Flutter reads it from the
  /// browser — or null on a phone or tablet.
  static AtlasPlatform? of(TargetPlatform platform) => switch (platform) {
    TargetPlatform.windows => AtlasPlatform.windows,
    TargetPlatform.macOS => AtlasPlatform.macOS,
    TargetPlatform.linux => AtlasPlatform.linux,
    _ => null,
  };
}

/// Every installer, for the "also for" row: (label, url).
const atlasInstallers = [
  ('Windows', AtlasDownloads.windows),
  ('macOS', AtlasDownloads.macOS),
  ('Linux AppImage', AtlasDownloads.linuxAppImage),
  ('Linux .deb', AtlasDownloads.linuxDeb),
];

import 'dart:io' show Platform;

bool get isAndroid => Platform.isAndroid;
bool get isMobile => Platform.isAndroid || Platform.isIOS;
bool get isDesktop =>
    Platform.isWindows || Platform.isMacOS || Platform.isLinux;
bool get isWindows => Platform.isWindows;
bool get isMacOS => Platform.isMacOS;
bool get isLinux => Platform.isLinux;
bool get isWeb => Platform.isFuchsia;
String get platformUserName => Platform.environment['USER'] ?? 'Unknown';

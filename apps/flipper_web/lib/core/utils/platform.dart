// This conditional export ensures we use the right implementation based on the platform
// For web (dart.library.html), we use platform_web.dart
// For non-web platforms (dart.library.io), we use platform_io.dart
export 'platform_web.dart' if (dart.library.io) 'platform_io.dart';

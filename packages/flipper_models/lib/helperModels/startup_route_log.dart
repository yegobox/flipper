import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Appends why startup sent the user to the login screen to
/// `startup_route.log` in the app-support directory.
///
/// Release desktop builds have no console, so without this a "reopened and
/// had to log in again" report leaves nothing to read. On Windows the file is
/// `%APPDATA%\rw\flipper\startup_route.log`.
class StartupRouteLog {
  StartupRouteLog._();

  static const fileName = 'startup_route.log';

  /// The log is trimmed back to nothing once it grows past this.
  static const _maxBytes = 256 * 1024;

  static Future<void> record(
    String reason, [
    Object? error,
    StackTrace? stackTrace,
  ]) async {
    if (kIsWeb) return;
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File('${dir.path}/$fileName');
      final keep = await file.exists() && await file.length() < _maxBytes;
      await file.writeAsString(
        format(DateTime.now(), reason, error, stackTrace),
        mode: keep ? FileMode.append : FileMode.write,
        flush: true,
      );
    } catch (e) {
      debugPrint('Failed to write $fileName: $e');
    }
  }

  @visibleForTesting
  static String format(
    DateTime at,
    String reason, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final buffer = StringBuffer('=== ${at.toIso8601String()} $reason\n');
    if (error != null) buffer.writeln('${error.runtimeType}: $error');
    if (stackTrace != null) buffer.writeln(stackTrace);
    return buffer.toString();
  }
}

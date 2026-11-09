/// A web-safe timing hook for work that can stall the UI thread.
///
/// A no-op by default. The desktop app points it at its UI-stall trail
/// (`ui_stall_monitoring.dart`), so a freeze during tracked work names it in
/// `ui_stall` telemetry and `perf.log`. Packages that also build for the web
/// call this instead of importing the `dart:io`-based watchdog.
abstract final class PerfTrack {
  static Future<T> Function<T>(String label, Future<T> Function() body) track =
      untracked;

  /// Runs [body] untimed; the default [track].
  static Future<T> untracked<T>(String label, Future<T> Function() body) =>
      body();
}

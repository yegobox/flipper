// Web implementation (no-op)
void setDevHttpOverrides() {
  // No-op for web
}

/// No-op placeholder for web builds. On IO platforms this is implemented in
/// `http_overrides_io.dart` and exports the real initialization that sets
/// `HttpOverrides.global` and trusted certificates.
Future<void> initializeCriticalDependencies() async {
  // Nothing to do for web.
}

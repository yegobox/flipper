/// Native builds use the SDK's own client; there is no posthog-js to load.
Future<bool> loadPostHogJs({
  required String projectToken,
  required String host,
  Duration timeout = const Duration(seconds: 20),
}) async => true;

bool get isPostHogJsReady => true;

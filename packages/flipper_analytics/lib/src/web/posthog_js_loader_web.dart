import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'posthog_js_host.dart';

@JS('posthog')
external _PostHogJs? get _posthog;

extension type _PostHogJs(JSObject _) implements JSObject {
  external JSAny? init(JSString token, JSObject config);
  // ignore: non_constant_identifier_names
  external JSBoolean? get __loaded;
}

bool _ready = false;
Future<bool>? _loading;

/// posthog_flutter on web only forwards calls to `window.posthog`; its
/// `setup()` does nothing. Books and HR never loaded posthog-js, so every
/// browser event was dropped without an error. This loads the CDN bundle
/// and initializes it with the token from `secrets.dart`, so the token
/// doesn't have to be committed in `web/index.html`.
bool get isPostHogJsReady => _ready;

Future<bool> loadPostHogJs({
  required String projectToken,
  required String host,
  Duration timeout = const Duration(seconds: 20),
}) {
  return _loading ??= _load(projectToken, host, timeout).then((ok) {
    // A failed load (offline, blocked) may be retried by the next caller.
    if (!ok) _loading = null;
    return ok;
  });
}

Future<bool> _load(String token, String host, Duration timeout) async {
  if (_posthog?.__loaded?.toDart ?? false) return _ready = true;

  final loaded = Completer<bool>();
  final script = web.HTMLScriptElement()
    ..src = assetsHostFor(host)
    ..async = true
    ..crossOrigin = 'anonymous';
  script.onload = ((web.Event _) => loaded.complete(true)).toJS;
  script.onerror = ((web.Event _) {
    if (!loaded.isCompleted) loaded.complete(false);
  }).toJS;
  web.document.head?.append(script);

  final ok = await loaded.future.timeout(timeout, onTimeout: () => false);
  final posthog = _posthog;
  if (!ok || posthog == null) {
    script.remove();
    return false;
  }
  posthog.init(
    token.toJS,
    {
          'api_host': host,
          // Matches native: people only once identified, no DOM autocapture or
          // replay; screens come from the router observer, not page loads.
          'person_profiles': 'identified_only',
          'autocapture': false,
          'capture_pageview': false,
          'capture_pageleave': false,
          'disable_session_recording': true,
        }.jsify()!
        as JSObject,
  );
  return _ready = true;
}

import 'dart:async';

import 'package:flipper_models/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Reachability check that holds up on mobile carriers.
///
/// `InternetConnectionChecker` alone only opens TCP :53 to public DNS
/// resolvers (1.1.1.1, 8.8.4.4, 208.67.222.222). Many mobile networks drop
/// that traffic, so a phone with working data waited 10s and was reported
/// offline — PIN login then treated a correct PIN as unknown. Here any HTTP
/// answer (even 401/404) from our API or a public 204 endpoint counts as
/// online, raced against the DNS probe; the first success wins.
class InternetProbe {
  InternetProbe._();

  static const Duration _timeout = Duration(seconds: 5);
  static const Duration _positiveTtl = Duration(seconds: 15);

  static final InternetConnectionChecker _dns =
      InternetConnectionChecker.createInstance(checkTimeout: _timeout);

  static DateTime? _lastOnlineAt;
  static Future<bool>? _inFlight;

  static List<Uri> get _httpTargets => [
    Uri.parse(AppSecrets.apihubProd),
    Uri.parse('https://www.google.com/generate_204'),
  ];

  /// True when any probe target answers within [_timeout].
  static Future<bool> isOnline() {
    final last = _lastOnlineAt;
    if (last != null && DateTime.now().difference(last) < _positiveTtl) {
      return Future.value(true);
    }
    return _inFlight ??= _probe().whenComplete(() => _inFlight = null);
  }

  static Future<bool> _probe() async {
    final result = Completer<bool>();
    final probes = <Future<bool>>[
      for (final uri in _httpTargets) _httpReachable(uri),
      _dnsReachable(),
    ];
    var pending = probes.length;
    for (final probe in probes) {
      unawaited(
        probe.then((ok) {
          pending--;
          if (result.isCompleted) return;
          if (ok) {
            _lastOnlineAt = DateTime.now();
            result.complete(true);
          } else if (pending == 0) {
            _lastOnlineAt = null;
            result.complete(false);
          }
        }),
      );
    }
    return result.future;
  }

  static Future<bool> _httpReachable(Uri uri) async {
    final client = http.Client();
    try {
      await client.head(uri).timeout(_timeout);
      return true;
    } catch (_) {
      return false;
    } finally {
      client.close();
    }
  }

  static Future<bool> _dnsReachable() async {
    try {
      return await _dns.hasConnection.timeout(
        _timeout + const Duration(seconds: 1),
      );
    } catch (_) {
      return false;
    }
  }
}

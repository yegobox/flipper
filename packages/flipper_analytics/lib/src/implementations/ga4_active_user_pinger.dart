import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../events/analytics_properties.dart';
import '../interfaces/analytics_context_provider.dart';

/// Reports this install as an active user to a GA4 data stream through the
/// Measurement Protocol.
///
/// Firebase Analytics has no Windows SDK, so the Firebase console shows 0 DAU
/// for the Windows app no matter how many tills run. This sends one
/// `app_active` event (with `session_id` and `engagement_time_msec`, which is
/// what GA4 needs to count an active user) on cold start, on resume and every
/// [heartbeat] while in the foreground — a till stays open for days, so a
/// launch-only ping would count it once.
///
/// It must never affect the till: nothing is awaited by callers, nothing is
/// queued, every failure is swallowed, offline skips the send and at most one
/// request is in flight. [isEnabled] is checked before every send so a mode
/// that forbids cloud traffic can switch it off.
class Ga4ActiveUserPinger with WidgetsBindingObserver {
  Ga4ActiveUserPinger({
    required this.measurementId,
    required this.apiSecret,
    required AnalyticsContextProvider contextProvider,
    http.Client Function()? createClient,
    Future<SharedPreferences> Function()? preferences,
    DateTime Function()? clock,
    Future<bool> Function()? hasNetwork,
    bool Function()? isEnabled,
    this.heartbeat = const Duration(minutes: 15),
    this.validateOnly = kDebugMode,
  }) : _contextProvider = contextProvider,
       _createClient = createClient ?? http.Client.new,
       _preferences = preferences ?? SharedPreferences.getInstance,
       _clock = clock ?? DateTime.now,
       _hasNetwork = hasNetwork ?? _connectivityHasNetwork,
       _isEnabled = isEnabled ?? _alwaysEnabled;

  static const eventName = 'app_active';
  static const clientIdKey = 'ga4_mp_client_id';
  static const sessionTimeout = Duration(minutes: 30);
  static const requestTimeout = Duration(seconds: 10);
  static const _networkCheckTimeout = Duration(seconds: 5);

  final String measurementId;
  final String apiSecret;
  final Duration heartbeat;

  /// Sends to `/debug/mp/collect`, which validates without recording, so
  /// debug runs never count as real users.
  final bool validateOnly;

  final AnalyticsContextProvider _contextProvider;
  final http.Client Function() _createClient;
  final Future<SharedPreferences> Function() _preferences;
  final DateTime Function() _clock;
  final Future<bool> Function() _hasNetwork;
  final bool Function() _isEnabled;

  bool _attached = false;
  bool _inFlight = false;
  Timer? _timer;
  // Created on the first send and closed on detach: the pinger owns it, so a
  // detached pinger leaves no keep-alive connection behind.
  http.Client? _client;
  String? _clientId;
  int? _sessionId;
  DateTime? _engagedSince;
  DateTime? _backgroundedAt;

  void attach() {
    if (_attached) return;
    _attached = true;
    WidgetsBinding.instance.addObserver(this);
    _startSession();
    _enterForeground();
  }

  Future<void> detach() async {
    if (!_attached) return;
    WidgetsBinding.instance.removeObserver(this);
    _attached = false;
    _timer?.cancel();
    _timer = null;
    _client?.close();
    _client = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_attached) return;
    switch (state) {
      case AppLifecycleState.resumed:
        final backgroundedAt = _backgroundedAt;
        if (backgroundedAt == null) return;
        _backgroundedAt = null;
        if (_clock().difference(backgroundedAt) >= sessionTimeout) {
          _startSession();
        }
        _enterForeground();
      // An unfocused desktop window is still a till in use; only a hidden or
      // closed one stops counting.
      case AppLifecycleState.inactive:
        return;
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (_backgroundedAt != null) return;
        _backgroundedAt = _clock();
        _timer?.cancel();
        _timer = null;
    }
  }

  void _startSession() {
    _sessionId = _clock().millisecondsSinceEpoch ~/ 1000;
  }

  void _enterForeground() {
    _engagedSince = _clock();
    _timer?.cancel();
    _timer = Timer.periodic(heartbeat, (_) => unawaited(_ping()));
    unawaited(_ping());
  }

  Future<void> _ping() async {
    if (!_attached || _inFlight) return;
    _inFlight = true;
    try {
      if (!_isEnabled()) return;
      final online = await _hasNetwork().timeout(
        _networkCheckTimeout,
        onTimeout: () => false,
      );
      if (!online || !_attached) return;

      final clientId = await _loadClientId();
      // detach() may have run while the client id was loading.
      if (!_attached) return;
      final now = _clock();
      final engagedSince = _engagedSince ?? now;
      _engagedSince = now;
      final engagementMs = math.max(
        1,
        now.difference(engagedSince).inMilliseconds,
      );

      final client = _client ??= _createClient();
      final http.Response response;
      try {
        response = await client
            .post(
              _endpoint,
              headers: const {'Content-Type': 'application/json'},
              body: jsonEncode(_payload(clientId, engagementMs)),
            )
            .timeout(requestTimeout);
      } on TimeoutException {
        // The timeout ends the wait, not the request. Closing the client
        // aborts it, so a slow network can't leave requests piling up; the
        // next ping opens a fresh client.
        if (identical(_client, client)) _client = null;
        client.close();
        rethrow;
      }
      if (kDebugMode) _debugReport(response);
    } catch (error) {
      if (kDebugMode) debugPrint('GA4 active-user ping skipped: $error');
    } finally {
      _inFlight = false;
    }
  }

  Uri get _endpoint => Uri.https(
    'www.google-analytics.com',
    validateOnly ? '/debug/mp/collect' : '/mp/collect',
    {'measurement_id': measurementId, 'api_secret': apiSecret},
  );

  Map<String, Object?> _payload(String clientId, int engagementMs) {
    final base = _contextProvider.buildBaseProperties();
    final userId = _contextProvider.userId;
    final businessId = _contextProvider.businessId;
    final branchId = _contextProvider.branchId;
    return {
      'client_id': clientId,
      if (userId != null && userId.isNotEmpty) 'user_id': userId,
      'events': [
        {
          'name': eventName,
          'params': {
            'session_id': '$_sessionId',
            'engagement_time_msec': engagementMs,
            if (base[AnalyticsProperties.platform] != null)
              AnalyticsProperties.platform:
                  '${base[AnalyticsProperties.platform]}',
            if (businessId != null) AnalyticsProperties.businessId: businessId,
            if (branchId != null) AnalyticsProperties.branchId: branchId,
          },
        },
      ],
    };
  }

  Future<String> _loadClientId() async {
    final cached = _clientId;
    if (cached != null) return cached;
    final prefs = await _preferences();
    var clientId = prefs.getString(clientIdKey);
    if (clientId == null || clientId.isEmpty) {
      clientId = const Uuid().v4();
      await prefs.setString(clientIdKey, clientId);
    }
    return _clientId = clientId;
  }

  void _debugReport(http.Response response) {
    if (!validateOnly) {
      debugPrint('GA4 active-user ping: HTTP ${response.statusCode}');
      return;
    }
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(
        'GA4 active-user ping validationMessages: '
        '${body['validationMessages']}',
      );
    } catch (_) {
      debugPrint('GA4 active-user ping: HTTP ${response.statusCode}');
    }
  }

  static bool _alwaysEnabled() => true;

  static Future<bool> _connectivityHasNetwork() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}

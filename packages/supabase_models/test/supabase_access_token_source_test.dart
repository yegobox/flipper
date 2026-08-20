import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/repository/auth_refreshing_client.dart';

String _fakeAccessToken({required int expiresInSeconds}) {
  final exp = DateTime.now()
          .add(Duration(seconds: expiresInSeconds))
          .millisecondsSinceEpoch ~/
      1000;
  final payload = base64Url.encode(utf8.encode(jsonEncode({'exp': exp})));
  return 'header.$payload.signature';
}

String _sessionJson({required String userId, required int expiresInSeconds}) {
  return jsonEncode({
    'access_token': _fakeAccessToken(expiresInSeconds: expiresInSeconds),
    'token_type': 'bearer',
    'refresh_token': 'refresh-$userId',
    'user': {'id': userId, 'created_at': DateTime.now().toIso8601String()},
  });
}

/// Answers every request with a bare `{}` unless a canned session has been
/// queued for the next `/token` call, which is how `auth.refreshSession()`
/// (the no-callback fallback in [SupabaseAccessTokenSource]) is exercised
/// without a real network round trip.
class _ScriptableHttpClient extends http.BaseClient {
  int tokenRequests = 0;
  String? nextSessionJson;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.endsWith('/token') && request.method == 'POST') {
      tokenRequests++;
      final body = nextSessionJson;
      if (body != null) {
        nextSessionJson = null;
        return http.StreamedResponse(
          Stream.value(utf8.encode(body)),
          200,
          request: request,
          headers: const {'content-type': 'application/json'},
        );
      }
    }
    return http.StreamedResponse(
      Stream.value(utf8.encode('{}')),
      200,
      request: request,
      headers: const {'content-type': 'application/json'},
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late _ScriptableHttpClient httpClient;
  late GoTrueClient auth;

  setUpAll(() async {
    httpClient = _ScriptableHttpClient();
    await Supabase.initialize(
      url: 'https://project.supabase.co',
      anonKey: 'anon-key',
      httpClient: httpClient,
      authOptions: const FlutterAuthClientOptions(detectSessionInUri: false),
    );
    auth = Supabase.instance.client.auth;
  });

  tearDownAll(() => Supabase.instance.dispose());

  setUp(() async {
    await auth.signOut();
    httpClient.tokenRequests = 0;
    httpClient.nextSessionJson = null;
  });

  group('no session', () {
    test('establishes a session via the injected callback', () async {
      var ensureCalls = 0;
      final source = SupabaseAccessTokenSource(
        ensureAccessToken: () async {
          ensureCalls++;
          await auth.setInitialSession(
            _sessionJson(userId: 'user-a', expiresInSeconds: 3600),
          );
          return auth.currentSession!.accessToken;
        },
      );

      final result = await source.current();

      expect(ensureCalls, 1);
      expect(result?.userId, 'user-a');
      expect(source.currentUserId, 'user-a');
    });

    test('returns null and records the failure when establishing fails',
        () async {
      var ensureCalls = 0;
      final source = SupabaseAccessTokenSource(
        ensureAccessToken: () async {
          ensureCalls++;
          return null;
        },
      );

      final result = await source.current();
      expect(result, isNull);
      expect(ensureCalls, 1);

      final second = await source.current();
      expect(second, isNull,
          reason: 'still within the post-failure cooldown');
      expect(ensureCalls, 1, reason: 'must not retry during the cooldown');
    });

    test('falls back to auth.refreshSession() when no callback is injected',
        () async {
      final source = SupabaseAccessTokenSource();

      final result = await source.current();

      expect(result, isNull, reason: 'there is no refresh token to use');
    });

    test('deduplicates concurrent establish attempts', () async {
      var ensureCalls = 0;
      final gate = Completer<void>();
      final source = SupabaseAccessTokenSource(
        ensureAccessToken: () async {
          ensureCalls++;
          await gate.future;
          await auth.setInitialSession(
            _sessionJson(userId: 'user-a', expiresInSeconds: 3600),
          );
          return auth.currentSession!.accessToken;
        },
      );

      final first = source.current();
      final second = source.current();
      gate.complete();

      final results = await Future.wait([first, second]);
      expect(ensureCalls, 1);
      expect(results[0]?.userId, 'user-a');
      expect(results[1]?.userId, 'user-a');
    });
  });

  group('existing session', () {
    test('returns it directly without establishing when not expiring',
        () async {
      await auth.setInitialSession(
        _sessionJson(userId: 'user-a', expiresInSeconds: 3600),
      );
      var ensureCalls = 0;
      final source = SupabaseAccessTokenSource(
        ensureAccessToken: () async {
          ensureCalls++;
          return null;
        },
      );

      final result = await source.current();

      expect(ensureCalls, 0);
      expect(result?.userId, 'user-a');
    });

    test('treats a session inside the expiry leeway as expiring', () async {
      await auth.setInitialSession(
        _sessionJson(userId: 'user-a', expiresInSeconds: 30),
      );
      var ensureCalls = 0;
      final source = SupabaseAccessTokenSource(
        ensureAccessToken: () async {
          ensureCalls++;
          await auth.setInitialSession(
            _sessionJson(userId: 'user-a', expiresInSeconds: 3600),
          );
          return auth.currentSession!.accessToken;
        },
      );

      await source.current();

      expect(ensureCalls, 1);
    });

    test('refreshes an already-expired session via the network fallback',
        () async {
      await auth.setInitialSession(
        _sessionJson(userId: 'user-a', expiresInSeconds: -60),
      );
      httpClient.nextSessionJson =
          _sessionJson(userId: 'user-a', expiresInSeconds: 3600);
      final source = SupabaseAccessTokenSource();

      final result = await source.current();

      expect(httpClient.tokenRequests, 1);
      expect(result?.userId, 'user-a');
    });
  });

  group('currentUserId', () {
    test('is null when signed out', () {
      final source = SupabaseAccessTokenSource();
      expect(source.currentUserId, isNull);
    });

    test('reflects the signed-in user without refreshing', () async {
      await auth.setInitialSession(
        _sessionJson(userId: 'user-a', expiresInSeconds: 3600),
      );
      final source = SupabaseAccessTokenSource();
      expect(source.currentUserId, 'user-a');
    });
  });
}

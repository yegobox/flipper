import 'dart:async';
import 'dart:convert';

import 'package:flipper_web/core/data_connector_web_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Tokens live in memory for the life of the page, so the thing that has to
/// be right is when they are thrown away. Sign-out does not reload the tab,
/// and refresh tokens rotate rather than lapsing, so a credential that
/// survives a sign-out survives indefinitely — into the next user's session.
void main() {
  const base = 'https://connector.invalid/';

  String tokenResponse(String access, String refresh) => jsonEncode({
    'deviceId': 'dev-1',
    'accessToken': access,
    'refreshToken': refresh,
    'expiresIn': 900,
  });

  late StreamController<String?> identity;

  setUp(() => identity = StreamController<String?>.broadcast());
  tearDown(() => identity.close());

  DataConnectorWebAuth build(http.Client client, {String? Function()? token}) =>
      DataConnectorWebAuth(
        client: client,
        identityChanges: identity.stream,
        currentIdentityToken: token ?? () => 'supabase-user-a',
      );

  test('enrols once and reuses the cached token', () async {
    var calls = 0;
    final auth = build(
      MockClient((req) async {
        calls++;
        return http.Response(tokenResponse('acc-1', 'ref-1'), 200);
      }),
    );

    expect(await auth.authHeaders(baseUrl: base), {
      'Authorization': 'Bearer acc-1',
    });
    expect(await auth.authHeaders(baseUrl: base), {
      'Authorization': 'Bearer acc-1',
    });
    expect(calls, 1);
  });

  test('a stable per-tab installId survives re-enrolment', () async {
    // The connector keys its device row on (installId, userId). Echoing the
    // server's deviceId back, or minting a fresh timestamp each time, opens a
    // new row on every re-enrolment.
    final installIds = <String?>[];
    final auth = build(
      MockClient((req) async {
        if (req.url.path == '/auth/token') {
          return http.Response('{"error":"dead"}', 401);
        }
        installIds.add(jsonDecode(req.body)['installId'] as String?);
        return http.Response(tokenResponse('acc-1', 'ref-1'), 200);
      }),
    );

    await auth.authHeaders(baseUrl: base);
    await auth.invalidateAccessToken();
    await auth.authHeaders(baseUrl: base);

    expect(installIds.length, 2);
    expect(installIds.first, isNotNull);
    expect(installIds[1], installIds.first);
  });

  test('signing out drops the cached credentials', () async {
    // The leak: without this the next user on the same tab inherits these.
    var enrolments = 0;
    final auth = build(
      MockClient((req) async {
        if (req.url.path == '/auth/enroll') enrolments++;
        return http.Response(tokenResponse('acc-1', 'ref-1'), 200);
      }),
    );

    expect(await auth.authHeaders(baseUrl: base), isNotEmpty);

    identity.add(null);
    await pumpEventQueue();

    // Still cached would mean the credentials outlived the session.
    expect(await auth.authHeaders(baseUrl: base), isNotEmpty);
    expect(enrolments, 2, reason: 'must enrol afresh, not reuse');
  });

  test('a different user does not inherit the previous tokens', () async {
    final seenIdentityTokens = <String?>[];
    var identityToken = 'supabase-user-a';
    final auth = build(
      MockClient((req) async {
        if (req.url.path == '/auth/enroll') {
          seenIdentityTokens.add(
            jsonDecode(req.body)['supabaseAccessToken'] as String?,
          );
        }
        return http.Response(tokenResponse('acc-1', 'ref-1'), 200);
      }),
      token: () => identityToken,
    );

    await auth.authHeaders(baseUrl: base);

    identityToken = 'supabase-user-b';
    identity.add('user-b');
    await pumpEventQueue();
    await auth.authHeaders(baseUrl: base);

    expect(seenIdentityTokens, ['supabase-user-a', 'supabase-user-b']);
  });

  test('a sign-out mid-enrolment does not restore the credentials', () async {
    // The in-flight guard. An enrolment that started under user A must not
    // write its result back after A has signed out.
    final auth = build(
      MockClient((req) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return http.Response(tokenResponse('acc-a', 'ref-a'), 200);
      }),
      token: () => 'supabase-user-a',
    );

    final pending = auth.authHeaders(baseUrl: base);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    identity.add(null);
    await pending;

    // Whatever that attempt returned, nothing may remain cached for the
    // session that has since ended.
    expect(auth.debugHasCachedToken, isFalse);
  });

  test('a 401 during a refresh does not start a second refresh', () async {
    // Refresh tokens rotate; presenting a retired one reads as theft and
    // gets the device revoked.
    final presented = <String?>[];
    var first = true;
    final auth = build(
      MockClient((req) async {
        if (req.url.path == '/auth/token') {
          presented.add(jsonDecode(req.body)['refreshToken'] as String?);
        }
        await Future<void>.delayed(const Duration(milliseconds: 20));
        final n = first ? 'ref-1' : 'ref-2';
        first = false;
        return http.Response(tokenResponse('acc-1', n), 200);
      }),
    );

    await auth.authHeaders(baseUrl: base);
    await auth.invalidateAccessToken();

    final a = auth.authHeaders(baseUrl: base);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await auth.invalidateAccessToken();
    final b = auth.authHeaders(baseUrl: base);
    await Future.wait([a, b]);

    expect(presented, ['ref-1'], reason: 'ref-1 presented exactly once');
  });
}

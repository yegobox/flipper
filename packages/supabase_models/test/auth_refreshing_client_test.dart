import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/repository/auth_refreshing_client.dart';

/// Records what actually reached the wire.
class _RecordingClient extends http.BaseClient {
  final List<http.BaseRequest> sent = [];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    sent.add(request);
    return http.StreamedResponse(const Stream.empty(), 200, request: request);
  }
}

class _FakeTokenSource implements AccessTokenSource {
  QueuedAuth? auth;
  int refreshCount = 0;

  _FakeTokenSource({this.auth});

  factory _FakeTokenSource.signedInAs(String userId) => _FakeTokenSource(
        auth: (accessToken: 'fresh-$userId', userId: userId),
      );

  @override
  String? get currentUserId => auth?.userId;

  @override
  Future<QueuedAuth?> current() async {
    refreshCount++;
    return auth;
  }
}

void main() {
  const anonKey = 'anon-key';
  const restUrl = 'https://project.supabase.co/rest/v1/logs?id=eq.abc';

  late _RecordingClient inner;

  setUp(() => inner = _RecordingClient());

  http.Request request(String url, {String method = 'POST', String? queuedBy}) {
    final req = http.Request(method, Uri.parse(url))
      ..headers['Authorization'] = 'Bearer stale-token';
    if (queuedBy != null) req.headers[enqueuedUserHeader] = queuedBy;
    return req;
  }

  group('token refresh', () {
    test('replaces the stale token captured when the job was queued', () async {
      final client = AuthRefreshingClient(
        inner,
        anonKey: anonKey,
        tokenSource: _FakeTokenSource.signedInAs('user-a'),
      );

      await client.send(request(restUrl));

      expect(inner.sent.single.headers['Authorization'], 'Bearer fresh-user-a');
      expect(inner.sent.single.headers['apikey'], anonKey);
    });
  });

  group('cross-user replay', () {
    test('drops a job queued by a different user', () async {
      final client = AuthRefreshingClient(
        inner,
        anonKey: anonKey,
        tokenSource: _FakeTokenSource.signedInAs('user-b'),
      );

      final response = await client.send(request(restUrl, queuedBy: 'user-a'));

      expect(response.statusCode, 403,
          reason: 'must be outside reattemptForStatusCodes so it is discarded');
      expect(inner.sent, isEmpty,
          reason: "user A's write must not be committed as user B");
    });

    test('sends a job queued by the same user, without leaking the stamp',
        () async {
      final client = AuthRefreshingClient(
        inner,
        anonKey: anonKey,
        tokenSource: _FakeTokenSource.signedInAs('user-a'),
      );

      await client.send(request(restUrl, queuedBy: 'user-a'));

      expect(inner.sent, hasLength(1));
      expect(inner.sent.single.headers.containsKey(enqueuedUserHeader), isFalse,
          reason: 'the stamp is internal and must not reach Supabase');
    });

    test('sends untagged jobs queued before uid tagging existed', () async {
      final client = AuthRefreshingClient(
        inner,
        anonKey: anonKey,
        tokenSource: _FakeTokenSource.signedInAs('user-b'),
      );

      await client.send(request(restUrl));

      expect(inner.sent, hasLength(1),
          reason: 'pre-existing queue rows must not be discarded wholesale');
    });
  });

  group('with no session', () {
    late AuthRefreshingClient client;

    setUp(() {
      client = AuthRefreshingClient(
        inner,
        anonKey: anonKey,
        tokenSource: _FakeTokenSource(),
      );
    });

    test('holds PostgREST writes instead of sending them unauthenticated',
        () async {
      final response = await client.send(request(restUrl));

      expect(response.statusCode, 503,
          reason: 'must be retryable so the queue keeps the job');
      expect(inner.sent, isEmpty);
    });

    test('holds rather than drops a tagged job', () async {
      final response = await client.send(request(restUrl, queuedBy: 'user-a'));

      expect(response.statusCode, 503,
          reason: 'user A may sign back in; the write should survive');
    });

    test('synthesized body parses as a PostgREST error', () async {
      final response = await client.send(request(restUrl));
      final body = await response.stream.bytesToString();

      expect(
        jsonDecode(body),
        containsPair('message', 'No active Supabase session'),
      );
    });

    test('holds storage and functions writes too', () async {
      for (final path in ['/storage/v1/object/x', '/functions/v1/x']) {
        final response =
            await client.send(request('https://project.supabase.co$path'));
        expect(response.statusCode, 503, reason: path);
      }
      expect(inner.sent, isEmpty);
    });
  });

  group('passthrough', () {
    late AuthRefreshingClient client;

    setUp(() {
      client = AuthRefreshingClient(
        inner,
        anonKey: anonKey,
        tokenSource: _FakeTokenSource.signedInAs('user-a'),
      );
    });

    test('forwards auth requests untouched', () async {
      await client
          .send(request('https://project.supabase.co/auth/v1/token?g=x'));

      expect(
        inner.sent.single.headers['Authorization'],
        'Bearer stale-token',
        reason: 'rewriting the token endpoint would break session refresh',
      );
    });

    test('forwards non-Supabase requests untouched', () async {
      await client.send(request('https://example.com/api/thing'));

      expect(inner.sent.single.headers['Authorization'], 'Bearer stale-token');
      expect(inner.sent.single.headers.containsKey('apikey'), isFalse);
    });
  });

  group('EnqueuedUserStampClient', () {
    test('tags writes with the signed-in uid', () async {
      final client = EnqueuedUserStampClient(
        inner,
        tokenSource: _FakeTokenSource.signedInAs('user-a'),
      );

      await client.send(request(restUrl));

      expect(inner.sent.single.headers[enqueuedUserHeader], 'user-a');
    });

    test('does not tag reads, auth calls, or signed-out writes', () async {
      final signedIn = EnqueuedUserStampClient(
        inner,
        tokenSource: _FakeTokenSource.signedInAs('user-a'),
      );
      final signedOut = EnqueuedUserStampClient(
        inner,
        tokenSource: _FakeTokenSource(),
      );

      await signedIn.send(request(restUrl, method: 'GET'));
      await signedIn
          .send(request('https://project.supabase.co/auth/v1/token?g=x'));
      await signedOut.send(request(restUrl));

      expect(
        inner.sent.where((r) => r.headers.containsKey(enqueuedUserHeader)),
        isEmpty,
      );
    });

    test('round-trips through the queue into AuthRefreshingClient', () async {
      // The stamp is applied above the queue and read below it, so the two
      // halves must agree on the header.
      final stamped = EnqueuedUserStampClient(
        _RecordingClient(),
        tokenSource: _FakeTokenSource.signedInAs('user-a'),
      );
      final outbound = request(restUrl);
      await stamped.send(outbound);

      // Simulate the queue serializing and replaying the headers verbatim.
      final replayed = http.Request('POST', outbound.url)
        ..headers.addAll(jsonDecode(jsonEncode(outbound.headers))
            .cast<String, String>());

      final response = await AuthRefreshingClient(
        inner,
        anonKey: anonKey,
        tokenSource: _FakeTokenSource.signedInAs('user-b'),
      ).send(replayed);

      expect(response.statusCode, 403);
      expect(inner.sent, isEmpty);
    });
  });
}

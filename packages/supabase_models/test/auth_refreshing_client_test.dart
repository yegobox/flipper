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

void main() {
  const anonKey = 'anon-key';
  late _RecordingClient inner;
  late AuthRefreshingClient client;

  setUp(() {
    inner = _RecordingClient();
    client = AuthRefreshingClient(inner, anonKey: anonKey);
  });

  http.Request request(String url) => http.Request('POST', Uri.parse(url))
    ..headers['Authorization'] = 'Bearer stale-token';

  group('with no Supabase session', () {
    test('holds PostgREST writes instead of sending them unauthenticated',
        () async {
      final response = await client.send(
        request('https://project.supabase.co/rest/v1/logs?id=eq.abc'),
      );

      expect(response.statusCode, 503,
          reason: 'must be retryable so the queue keeps the job');
      expect(inner.sent, isEmpty,
          reason: 'no request should reach Supabase without a live token');
    });

    test('synthesized body parses as a PostgREST error', () async {
      final response = await client.send(
        request('https://project.supabase.co/rest/v1/logs'),
      );
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
    test('forwards auth requests untouched', () async {
      final auth =
          request('https://project.supabase.co/auth/v1/token?grant_type=x');

      final response = await client.send(auth);

      expect(response.statusCode, 200);
      expect(inner.sent, hasLength(1));
      expect(
        inner.sent.single.headers['Authorization'],
        'Bearer stale-token',
        reason: 'rewriting the token endpoint would break session refresh',
      );
    });

    test('forwards non-Supabase requests untouched', () async {
      await client.send(request('https://example.com/api/thing'));

      expect(inner.sent, hasLength(1));
      expect(inner.sent.single.headers['Authorization'], 'Bearer stale-token');
      expect(inner.sent.single.headers.containsKey('apikey'), isFalse);
    });
  });
}

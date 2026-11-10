import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/repository/auth_refreshing_client.dart';

/// Records what reached the wire.
class _RecordingClient extends http.BaseClient {
  final List<http.BaseRequest> sent = [];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    sent.add(request);
    return http.StreamedResponse(const Stream.empty(), 200, request: request);
  }
}

void main() {
  // Deliberately never calls Supabase.initialize in this file — each test
  // file runs in its own isolate, so `Supabase.instance` here is genuinely
  // unestablished, exercising the LateInitializationError caught by `_auth`.
  test('currentUserId and current() are null before Supabase.initialize runs',
      () async {
    final source = SupabaseAccessTokenSource();

    expect(source.currentUserId, isNull);
    expect(await source.current(), isNull);
  });

  test('the queue clients read the Supabase session when given no source',
      () async {
    final inner = _RecordingClient();
    final rest = Uri.parse('https://project.supabase.co/rest/v1/logs');

    // No session yet: the write is stamped as signed out...
    await EnqueuedUserStampClient(inner).send(http.Request('POST', rest));
    expect(
        inner.sent.single.headers[enqueuedUserHeader], signedOutEnqueuedUser);

    // ...and held in the queue rather than sent unauthenticated.
    final held = await AuthRefreshingClient(inner, anonKey: 'anon')
        .send(http.Request('POST', rest));
    expect(held.statusCode, 503);
    expect(inner.sent, hasLength(1));
  });
}

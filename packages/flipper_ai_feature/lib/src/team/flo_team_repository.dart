import 'dart:convert';

import 'package:flipper_models/data_connector_client.dart';
import 'package:http/http.dart' as http;

import 'flo_team_models.dart';

class FloTeamException implements Exception {
  FloTeamException(this.message, {this.statusCode});

  final String message;

  /// The HTTP status, when the server answered.
  final int? statusCode;

  /// The caller is not (or no longer) an invited member.
  bool get notMember => statusCode == 403;

  @override
  String toString() => message;
}

/// Flo Team, as data-connector serves it (`/api/flo/team/*`). The server
/// decides membership from the device's own token; nothing here is trusted.
abstract class FloTeamRepository {
  Future<FloTeamMe> me();
  Future<List<FloTeamMember>> members();

  /// Staff of the business not yet in the team (managers only).
  Future<List<FloTeamMember>> colleagues();
  Future<void> invite(String userId);
  Future<void> remove(String userId);

  /// What changed since [since] (everything when null).
  Future<FloTeamChanges> changes({String? since});
  Future<FloTeamThread> createThread({
    required String kind,
    required String title,
    String body = '',
  });

  /// [changes] uses the API's keys: `title`, `body`, `status`,
  /// `assigneeUserId`, `dueDate` (YYYY-MM-DD); a null value clears it.
  Future<FloTeamThread> updateThread(String id, Map<String, Object?> changes);
  Future<void> post(String threadId, String body, {List<String> mentions});
  Future<void> vote(String threadId, {required bool on});

  /// Flo answers in the thread; its answer arrives as a post.
  Future<void> askFlo(String threadId, {String question});
  Future<void> summarize(String threadId);
  Future<void> markRead({String? threadId});
}

/// [FloTeamRepository] over HTTP, signed with the device's connector token
/// ([DataConnectorClient]), like Ask Flo.
class HttpFloTeamRepository implements FloTeamRepository {
  HttpFloTeamRepository({
    required Future<String> Function() baseUrl,
    http.Client? client,
  })  : _baseUrl = baseUrl,
        _client = client ?? http.Client();

  final Future<String> Function() _baseUrl;
  final http.Client _client;

  static const _timeout = Duration(seconds: 30);

  /// Flo reads the business's data before answering, like Ask Flo.
  static const _floTimeout = Duration(minutes: 3);

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Object? body,
    Duration timeout = _timeout,
  }) async {
    final base = await _baseUrl();
    final client = DataConnectorClient(baseUrl: base, inner: _client);
    final request = http.Request(method, Uri.parse('${base}api/flo/team/$path'))
      ..headers['Content-Type'] = 'application/json';
    if (body != null) request.body = jsonEncode(body);
    final http.Response response;
    try {
      response = await http.Response.fromStream(
          await client.send(request).timeout(timeout));
    } catch (e) {
      throw FloTeamException('Could not reach Flo Team: $e');
    }
    final decoded = _decode(response.body);
    if (response.statusCode != 200) {
      throw FloTeamException(
        (decoded['error'] as String?) ??
            'Flo Team request failed (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
    return decoded;
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      final value = jsonDecode(body);
      return value is Map ? Map<String, dynamic>.from(value) : {};
    } catch (_) {
      return {};
    }
  }

  static List<Map<String, dynamic>> _rows(
          Map<String, dynamic> json, String key) =>
      (json[key] as List? ?? [])
          .whereType<Map>()
          .map((r) => Map<String, dynamic>.from(r))
          .toList();

  @override
  Future<FloTeamMe> me() async => FloTeamMe.fromJson(await _send('GET', 'me'));

  @override
  Future<List<FloTeamMember>> members() async =>
      _rows(await _send('GET', 'members'), 'members')
          .map(FloTeamMember.fromJson)
          .toList();

  @override
  Future<List<FloTeamMember>> colleagues() async =>
      _rows(await _send('GET', 'colleagues'), 'colleagues')
          .map(FloTeamMember.fromJson)
          .toList();

  @override
  Future<void> invite(String userId) =>
      _send('POST', 'members', body: {'userId': userId});

  @override
  Future<void> remove(String userId) =>
      _send('DELETE', 'members/${Uri.encodeComponent(userId)}');

  @override
  Future<FloTeamChanges> changes({String? since}) async {
    final query =
        since == null ? '' : '?since=${Uri.encodeQueryComponent(since)}';
    return FloTeamChanges.fromJson(await _send('GET', 'threads$query'));
  }

  @override
  Future<FloTeamThread> createThread({
    required String kind,
    required String title,
    String body = '',
  }) async {
    final json = await _send(
      'POST',
      'threads',
      body: {'kind': kind, 'title': title, 'body': body},
    );
    return FloTeamThread.fromJson(
        Map<String, dynamic>.from(json['thread'] as Map));
  }

  @override
  Future<FloTeamThread> updateThread(
    String id,
    Map<String, Object?> changes,
  ) async {
    final json = await _send('PATCH', 'threads/$id', body: changes);
    return FloTeamThread.fromJson(
        Map<String, dynamic>.from(json['thread'] as Map));
  }

  @override
  Future<void> post(
    String threadId,
    String body, {
    List<String> mentions = const [],
  }) =>
      _send(
        'POST',
        'threads/$threadId/posts',
        body: {'body': body, 'mentions': mentions},
      );

  @override
  Future<void> vote(String threadId, {required bool on}) =>
      _send(on ? 'POST' : 'DELETE', 'threads/$threadId/vote');

  @override
  Future<void> askFlo(String threadId, {String question = ''}) => _send(
        'POST',
        'threads/$threadId/ask',
        body: {'question': question},
        timeout: _floTimeout,
      );

  @override
  Future<void> summarize(String threadId) =>
      _send('POST', 'threads/$threadId/summarize', timeout: _floTimeout);

  @override
  Future<void> markRead({String? threadId}) => _send(
        'POST',
        'mentions/read',
        body: {if (threadId != null) 'threadId': threadId},
      );
}

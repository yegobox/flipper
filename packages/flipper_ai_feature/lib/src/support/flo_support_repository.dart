import 'dart:convert';

import 'package:flipper_models/data_connector_client.dart';
import 'package:http/http.dart' as http;

DateTime? _time(Object? raw) =>
    raw is String ? DateTime.tryParse(raw)?.toLocal() : null;

String _str(Object? raw) => raw is String ? raw : '';

class FloSupportException implements Exception {
  FloSupportException(this.message, {this.statusCode});

  final String message;

  /// The HTTP status, when the server answered.
  final int? statusCode;

  /// Support chat is switched off on this connector.
  bool get unavailable => statusCode == 503;

  @override
  String toString() => message;
}

/// One message of the conversation with Flipper Support.
class FloSupportPost {
  const FloSupportPost({
    required this.id,
    required this.body,
    required this.fromSupport,
    required this.authorName,
    this.mine = false,
    this.createdAt,
  });

  factory FloSupportPost.fromJson(Map<String, dynamic> json) => FloSupportPost(
        id: _str(json['id']),
        body: _str(json['body']),
        fromSupport: json['fromSupport'] == true,
        authorName: _str(json['authorName']),
        mine: json['mine'] == true,
        createdAt: _time(json['createdAt']),
      );

  final String id;
  final String body;

  /// A reply from the support team, signed by the team, never a person.
  final bool fromSupport;
  final String authorName;

  /// Written by the signed-in user (not a colleague of theirs).
  final bool mine;
  final DateTime? createdAt;
}

/// The business's conversation with support, or what is new in it.
class FloSupportConversation {
  const FloSupportConversation({
    this.threadId,
    this.resolved = false,
    this.posts = const [],
    this.serverTime,
  });

  factory FloSupportConversation.fromJson(Map<String, dynamic> json) {
    final thread = json['thread'];
    return FloSupportConversation(
      threadId: thread is Map ? _str(thread['id']) : null,
      resolved: thread is Map && thread['status'] == 'done',
      posts: (json['posts'] as List? ?? [])
          .whereType<Map>()
          .map((p) => FloSupportPost.fromJson(Map<String, dynamic>.from(p)))
          .toList(),
      serverTime: json['serverTime'] as String?,
    );
  }

  /// Null until the business first writes (or after support archives it).
  final String? threadId;

  /// Support marked it resolved; writing again reopens it.
  final bool resolved;
  final List<FloSupportPost> posts;

  /// The `since` of the next poll.
  final String? serverTime;
}

/// Flo Support, as data-connector serves it (`/api/flo/support/*`). The
/// server takes the business and user from the device's own token.
abstract class FloSupportRepository {
  /// The conversation, or what changed since [since] (everything when null).
  Future<FloSupportConversation> conversation({String? since});

  /// Writes to support. [topic] is `payment` or `general`; [context] is what
  /// the screen shows (`planId`, `plan`, `amount`, `billing`,
  /// `paymentStatus`, `lastError`), so support need not ask.
  Future<FloSupportPost> send(
    String body, {
    String topic = 'general',
    Map<String, String>? context,
  });
}

/// [FloSupportRepository] over HTTP, signed with the device's connector token
/// ([DataConnectorClient]), like Flo Team.
class HttpFloSupportRepository implements FloSupportRepository {
  HttpFloSupportRepository({
    required Future<String> Function() baseUrl,
    http.Client? client,
  })  : _baseUrl = baseUrl,
        _client = client ?? http.Client();

  final Future<String> Function() _baseUrl;
  final http.Client _client;

  static const _timeout = Duration(seconds: 30);

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Object? body,
  }) async {
    final http.Response response;
    try {
      final base = await _baseUrl();
      final client = DataConnectorClient(baseUrl: base, inner: _client);
      final request =
          http.Request(method, Uri.parse('${base}api/flo/support/$path'))
            ..headers['Content-Type'] = 'application/json';
      if (body != null) request.body = jsonEncode(body);
      response = await client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(_timeout);
    } catch (e) {
      throw FloSupportException('Could not reach support: $e');
    }
    Map<String, dynamic> decoded;
    try {
      final value = jsonDecode(response.body);
      decoded = value is Map ? Map<String, dynamic>.from(value) : {};
    } catch (_) {
      decoded = {};
    }
    if (response.statusCode != 200) {
      throw FloSupportException(
        (decoded['error'] as String?) ??
            'Support request failed (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
    return decoded;
  }

  @override
  Future<FloSupportConversation> conversation({String? since}) async =>
      FloSupportConversation.fromJson(
        await _send(
          'GET',
          since == null
              ? 'thread'
              : 'thread?since=${Uri.encodeQueryComponent(since)}',
        ),
      );

  @override
  Future<FloSupportPost> send(
    String body, {
    String topic = 'general',
    Map<String, String>? context,
  }) async {
    final json = await _send('POST', 'messages', body: {
      'body': body,
      'topic': topic,
      if (context != null) 'context': context,
    });
    final post = json['post'];
    return FloSupportPost.fromJson(
      post is Map ? Map<String, dynamic>.from(post) : const {},
    );
  }
}

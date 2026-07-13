import 'dart:convert';

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Fresh journal entry status from the data-connector Ditto replica.
class JournalEntryRemoteStatus {
  const JournalEntryRemoteStatus({
    required this.entryId,
    required this.status,
    this.entryNumber,
    this.businessId,
  });

  factory JournalEntryRemoteStatus.fromJson(Map<String, dynamic> json) {
    return JournalEntryRemoteStatus(
      entryId: (json['entryId'] ?? json['entry_id'] ?? '').toString(),
      status: (json['status'] ?? 'draft').toString(),
      entryNumber: json['entryNumber'] as String? ?? json['entry_number'] as String?,
      businessId: json['businessId'] as String? ?? json['business_id'] as String?,
    );
  }

  final String entryId;
  final String status;
  final String? entryNumber;
  final String? businessId;

  bool get isPending => status == 'pending';
  bool get isPosted => status == 'posted';
}

/// Result of posting a pending journal entry via data-connector.
class JournalApproveResult {
  const JournalApproveResult({
    required this.posted,
    required this.entryId,
    required this.status,
    this.reason,
  });

  factory JournalApproveResult.fromJson(Map<String, dynamic> json) {
    return JournalApproveResult(
      posted: json['posted'] == true,
      entryId: (json['entryId'] ?? json['entry_id'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      reason: json['reason'] as String?,
    );
  }

  final bool posted;
  final String entryId;
  final String status;
  final String? reason;

  bool get alreadyPosted =>
      !posted && (reason == 'already_posted' || status == 'posted');
}

class JournalApprovalException implements Exception {
  JournalApprovalException(this.message, {this.isOffline = false});

  final String message;
  final bool isOffline;

  @override
  String toString() => message;
}

/// Approves journal entries through data-connector when online.
///
/// On network failure ([JournalApprovalException.isOffline]), callers should
/// fall back to local Ditto `postJournalEntry(onlyIfPending: true)`.
class JournalApprovalService {
  JournalApprovalService({
    http.Client? client,
    String? baseUrl,
    ProductAnalytics? analytics,
  })
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? _defaultBaseUrl,
        _analytics = analytics;

  static String get _defaultBaseUrl => kDebugMode
      ? 'http://localhost:8084'
      : 'https://data-connector.yegobox.com';

  final http.Client _client;
  final String _baseUrl;
  final ProductAnalytics? _analytics;

  Uri _entryUri(String entryId) =>
      Uri.parse('$_baseUrl/accounting/journal-entries/$entryId');

  Uri _approveUri(String entryId) =>
      Uri.parse('$_baseUrl/accounting/journal-entries/$entryId/approve');

  Future<JournalEntryRemoteStatus> fetchStatus(String entryId) async {
    final response = await _get(_entryUri(entryId));
    return JournalEntryRemoteStatus.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<JournalApproveResult> approve({
    required String entryId,
    String? businessId,
  }) async {
    final body = <String, dynamic>{};
    if (businessId != null && businessId.isNotEmpty) {
      body['businessId'] = businessId;
    }

    final response = await _post(
      _approveUri(entryId),
      body: body.isEmpty ? null : body,
    );
    await _analytics?.track(
      AnalyticsEvents.journalEntryPosted,
      properties: {
        'source': 'journal_approval_service',
        'entry_id': entryId,
        if (businessId != null) 'business_id': businessId,
      },
    );
    return JournalApproveResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<http.Response> _get(Uri uri) async {
    try {
      final response = await _client.get(uri);
      _throwIfError(response);
      return response;
    } on JournalApprovalException {
      rethrow;
    } catch (e) {
      throw JournalApprovalException(
        'Could not reach data-connector at $_baseUrl: $e',
        isOffline: true,
      );
    }
  }

  Future<http.Response> _post(Uri uri, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: body == null ? null : jsonEncode(body),
      );
      _throwIfError(response);
      return response;
    } on JournalApprovalException {
      rethrow;
    } catch (e) {
      throw JournalApprovalException(
        'Could not reach data-connector at $_baseUrl: $e',
        isOffline: true,
      );
    }
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    String message =
        'Journal approval request failed (${response.statusCode})';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        message = (decoded['error'] as String?) ?? message;
      }
    } catch (_) {}
    throw JournalApprovalException(message);
  }
}

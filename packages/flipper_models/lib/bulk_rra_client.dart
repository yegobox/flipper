import 'dart:convert';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:http/http.dart' as http;

/// HTTP client for data-connector bulk RRA jobs (`POST /rra/products/bulk-add`).
class BulkRraClient {
  BulkRraClient({required this.baseUrl, http.Client? httpClient})
    : _http = httpClient ?? http.Client(),
      _base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  final String baseUrl;
  final http.Client _http;
  final String _base;

  Future<BulkRraJobAccepted> submitBulkAdd({
    required String tinNumber,
    required String bhfId,
    required String branchId,
    required String businessId,
    required List<Map<String, dynamic>> rows,
    String? taxServerUrl,
    bool isTaxEnabled = true,
  }) async {
    final uri = Uri.parse('${_base}rra/products/bulk-add');
    final body = <String, dynamic>{
      'tinNumber': tinNumber,
      'bhfId': bhfId,
      'branchId': branchId,
      'businessId': businessId,
      'isTaxEnabled': isTaxEnabled,
      'rows': rows,
    };
    if (taxServerUrl != null && taxServerUrl.isNotEmpty) {
      body['taxServerUrl'] = taxServerUrl;
    }

    final response = await _http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 202) {
      talker.error(
        'bulk-add failed ${response.statusCode}: ${response.body}',
      );
      throw Exception(
        'Bulk RRA submit failed (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return BulkRraJobAccepted(
      jobId: decoded['jobId'] as String,
      accepted: decoded['accepted'] as int? ?? 0,
      status: decoded['status'] as String? ?? 'queued',
    );
  }

  Future<BulkRraJobStatus> pollJob(String jobId) async {
    final uri = Uri.parse('${_base}rra/jobs/$jobId');
    final response = await _http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        'Bulk RRA job poll failed (${response.statusCode}): ${response.body}',
      );
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return BulkRraJobStatus(
      jobId: decoded['jobId'] as String? ?? jobId,
      status: decoded['status'] as String? ?? 'unknown',
      accepted: decoded['accepted'] as int? ?? 0,
      queued: decoded['queued'] as int? ?? 0,
      processing: decoded['processing'] as int? ?? 0,
      success: decoded['success'] as int? ?? 0,
      failed: decoded['failed'] as int? ?? 0,
    );
  }

  Future<List<Map<String, dynamic>>> listFailedItems(String jobId) async {
    final uri = Uri.parse(
      '${_base}rra/jobs/$jobId/items?limit=1000&status=failed',
    );
    final response = await _http.get(uri);
    if (response.statusCode != 200) {
      return [];
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final items = decoded['items'] as List<dynamic>? ?? [];
    return items.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}

class BulkRraJobAccepted {
  BulkRraJobAccepted({
    required this.jobId,
    required this.accepted,
    required this.status,
  });

  final String jobId;
  final int accepted;
  final String status;
}

class BulkRraJobStatus {
  BulkRraJobStatus({
    required this.jobId,
    required this.status,
    required this.accepted,
    required this.queued,
    required this.processing,
    required this.success,
    required this.failed,
  });

  final String jobId;
  final String status;
  final int accepted;
  final int queued;
  final int processing;
  final int success;
  final int failed;

  int get completed => success + failed;

  bool get isTerminal {
    if (status == 'completed' || status == 'failed') {
      return true;
    }
    return accepted > 0 && completed >= accepted;
  }
}

/// Resolves data-connector base URL for bulk RRA (not upstream tax server).
Future<String> resolveDataConnectorBaseUrl({
  String? taxServerUrl,
  String? serverUrl,
}) async {
  final candidates = <String?>[
    serverUrl,
    taxServerUrl,
    'http://127.0.0.1:8084',
    'http://localhost:8084',
  ];
  for (final raw in candidates) {
    if (raw == null || raw.trim().isEmpty) continue;
    final trimmed = raw.trim();
    if (trimmed.contains(':8084') ||
        trimmed.contains('data-connector') ||
        trimmed.endsWith('/rra/') ||
        trimmed.endsWith('/rra')) {
      return trimmed.endsWith('/') ? trimmed : '$trimmed/';
    }
  }
  return 'http://127.0.0.1:8084/';
}

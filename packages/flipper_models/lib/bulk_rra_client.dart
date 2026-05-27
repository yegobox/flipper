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

    final response = await _http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(minutes: 15),
          onTimeout: () {
            throw Exception(
              'Bulk RRA submit timed out after 15 minutes (large file upload). '
              'Check data-connector is reachable and HTTP_MAX_BODY_MB / reverse proxy limits.',
            );
          },
        );

    if (response.statusCode != 202) {
      talker.error('bulk-add failed ${response.statusCode}: ${response.body}');
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
    final job = decoded['job'] as Map<String, dynamic>?;
    return BulkRraJobStatus(
      jobId: decoded['jobId'] as String? ?? jobId,
      status: decoded['status'] as String? ?? 'unknown',
      accepted: decoded['accepted'] as int? ?? 0,
      queued: decoded['queued'] as int? ?? 0,
      processing: decoded['processing'] as int? ?? 0,
      success: decoded['success'] as int? ?? 0,
      failed: decoded['failed'] as int? ?? 0,
      taxServerUrl: job?['taxServerUrl'] as String?,
    );
  }

  Future<List<Map<String, dynamic>>> listJobItems(
    String jobId, {
    String? status,
  }) async {
    final statusParam =
        status != null && status.isNotEmpty ? '&status=$status' : '';
    final uri = Uri.parse(
      '${_base}rra/jobs/$jobId/items?limit=1000$statusParam',
    );
    final response = await _http.get(uri);
    if (response.statusCode != 200) {
      talker.warning(
        'listJobItems failed ${response.statusCode}: ${response.body}',
      );
      return [];
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final items = decoded['items'] as List<dynamic>? ?? [];
    return items.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<List<Map<String, dynamic>>> listFailedItems(String jobId) async {
    return listJobItems(jobId, status: 'failed');
  }

  Future<List<Map<String, dynamic>>> listSuccessItems(String jobId) async {
    return listJobItems(jobId, status: 'success');
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
    this.taxServerUrl,
  });

  final String jobId;
  final String status;
  final int accepted;
  final int queued;
  final int processing;
  final int success;
  final int failed;
  final String? taxServerUrl;

  int get completed => success + failed;

  bool get isTerminal {
    if (queued > 0 || processing > 0) {
      return false;
    }
    if (status == 'failed' ||
        status == 'completed' ||
        status == 'completed_with_errors') {
      return accepted == 0 || completed >= accepted;
    }
    return accepted > 0 && completed >= accepted;
  }

  bool get usedLocalhostTaxUrl {
    final url = taxServerUrl?.toLowerCase() ?? '';
    return url.contains('localhost') || url.contains('127.0.0.1');
  }
}

/// Result shown in the bulk modal after save (server or legacy path).
class BulkSaveResult {
  BulkSaveResult({
    required this.success,
    required this.message,
    required this.total,
    required this.succeeded,
    required this.failed,
    this.jobId,
    this.rraSkipped = false,
  });

  final bool success;
  final String message;
  final int total;
  final int succeeded;
  final int failed;
  final String? jobId;

  /// True when catalog was written but RRA was not called (tax disabled).
  final bool rraSkipped;
}

/// Resolves data-connector base URL from [Ebm.dataConnectorUrl] (not the RRA tax URL).
Future<String> resolveDataConnectorBaseUrl({String? dataConnectorUrl}) async {
  final configured = dataConnectorUrl?.trim();
  if (configured != null && configured.isNotEmpty) {
    final normalized =
        configured.endsWith('/') ? configured : '$configured/';
    talker.info('Bulk RRA using data-connector at $normalized');
    return normalized;
  }
  talker.warning(
    'No data-connector URL configured on EBM; defaulting to http://127.0.0.1:8084/',
  );
  return 'http://127.0.0.1:8084/';
}

import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/data_connector_http_log.dart';
import 'package:flipper_models/imports_purchases_map.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/models/purchase.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Branch/business context required on every imports-purchases POST body.
class ImportPurchaseContext {
  const ImportPurchaseContext({
    required this.tinNumber,
    required this.bhfId,
    required this.branchId,
    required this.businessId,
    this.taxServerUrl,
    this.vatEnabled = true,
  });

  final String? taxServerUrl;
  final String tinNumber;
  final String bhfId;
  final String branchId;
  final String businessId;
  final bool vatEnabled;

  Map<String, dynamic> toJson({bool includeVatEnabled = false}) {
    final map = <String, dynamic>{
      'tinNumber': tinNumber,
      'bhfId': bhfId,
      'branchId': branchId,
      'businessId': businessId,
    };
    if (taxServerUrl != null && taxServerUrl!.isNotEmpty) {
      map['taxServerUrl'] = taxServerUrl;
    }
    if (includeVatEnabled) {
      map['vatEnabled'] = vatEnabled;
    }
    return map;
  }
}

/// HTTP client for data-connector imports/purchases endpoints.
class ImportsPurchasesClient {
  ImportsPurchasesClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.logHttp = true,
  }) : _http = httpClient ?? http.Client(),
       _base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  final String baseUrl;
  final http.Client _http;
  final String _base;

  /// When true, logs boxed request/response lines via [talker].
  final bool logHttp;

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  Map<String, dynamic> _decodeJsonObject(http.Response response) {
    final raw = response.body.trim();
    if (raw.isEmpty) {
      return const {};
    }
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
    throw FormatException(
      'Expected JSON object from data-connector, got ${decoded.runtimeType}',
    );
  }

  Future<List<Variant>> listImports(
    String branchId, {
    String? status,
    int? limit,
  }) async {
    final query = _listQuery(branchId: branchId, status: status, limit: limit);
    final uri = Uri.parse('${_base}imports?$query');
    final response = await _get(uri, label: 'list imports');
    _ensureOk(response, 'list imports');
    final decoded = _decodeJsonObject(response);
    final items = decoded['imports'] as List<dynamic>? ?? [];
    return items
        .map((e) => variantFromApiJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<Purchase>> listPurchases(
    String branchId, {
    String? status,
    int? limit,
  }) async {
    final query = _listQuery(branchId: branchId, status: status, limit: limit);
    final uri = Uri.parse('${_base}purchases?$query');
    final response = await _get(uri, label: 'list purchases');
    _ensureOk(response, 'list purchases');
    final decoded = _decodeJsonObject(response);
    final items = decoded['purchases'] as List<dynamic>? ?? [];
    return items
        .map((e) => purchaseFromApiJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<ImportPurchaseJobAccepted> syncImports(ImportPurchaseContext ctx) async {
    return _postJob(
      '${_base}imports/sync',
      ctx.toJson(includeVatEnabled: true),
      label: 'sync imports',
    );
  }

  Future<ImportPurchaseJobAccepted> syncPurchases(
    ImportPurchaseContext ctx,
  ) async {
    return _postJob(
      '${_base}purchases/sync',
      ctx.toJson(),
      label: 'sync purchases',
    );
  }

  Future<ImportPurchaseJobAccepted> approveImport(
    ImportPurchaseContext ctx, {
    required String variantId,
    String? targetVariantId,
    double? retailPrice,
    double? supplyPrice,
    String? itemNm,
  }) async {
    final body = ctx.toJson()
      ..['variantId'] = variantId;
    if (targetVariantId != null && targetVariantId.isNotEmpty) {
      body['targetVariantId'] = targetVariantId;
    }
    if (retailPrice != null && retailPrice > 0) {
      body['retailPrice'] = retailPrice;
    }
    if (supplyPrice != null && supplyPrice > 0) {
      body['supplyPrice'] = supplyPrice;
    }
    if (itemNm != null && itemNm.isNotEmpty) {
      body['itemNm'] = itemNm;
    }
    return _postJob('${_base}imports/approve', body, label: 'approve import');
  }

  Future<ImportPurchaseJobAccepted> rejectImport(
    ImportPurchaseContext ctx, {
    required String variantId,
  }) async {
    final body = ctx.toJson()..['variantId'] = variantId;
    return _postJob('${_base}imports/reject', body, label: 'reject import');
  }

  Future<ImportPurchaseJobAccepted> approvePurchase(
    ImportPurchaseContext ctx, {
    required String purchaseId,
    Map<String, List<String>> itemMapper = const {},
  }) async {
    final body = ctx.toJson()
      ..['purchaseId'] = purchaseId
      ..['itemMapper'] = itemMapper;
    return _postJob('${_base}purchases/approve', body, label: 'approve purchase');
  }

  Future<ImportPurchaseJobAccepted> rejectPurchase(
    ImportPurchaseContext ctx, {
    required String purchaseId,
  }) async {
    final body = ctx.toJson()..['purchaseId'] = purchaseId;
    return _postJob('${_base}purchases/reject', body, label: 'reject purchase');
  }

  /// Re-queue a failed job (same [jobId] and stored request payload).
  Future<ImportPurchaseJobAccepted> replayJob(String jobId) async {
    final uri = Uri.parse('${_base}imports-purchases/jobs/$jobId/replay');
    final response = await _post(uri, body: '{}', label: 'replay job');
    if (response.statusCode != 202) {
      throw Exception(
        'Import/purchase job replay failed (${response.statusCode}): ${response.body}',
      );
    }
    final decoded = _decodeJsonObject(response);
    return ImportPurchaseJobAccepted(
      jobId: decoded['jobId'] as String? ?? jobId,
      operation: decoded['operation'] as String? ?? '',
      status: decoded['status'] as String? ?? 'queued',
    );
  }

  Future<ImportPurchaseJobStatus> replayJobUntilTerminal(
    String jobId, {
    Duration interval = const Duration(seconds: 1),
    Duration timeout = const Duration(minutes: 5),
  }) async {
    final accepted = await replayJob(jobId);
    return pollJobUntilTerminal(
      accepted.jobId,
      interval: interval,
      timeout: timeout,
    );
  }

  Future<ImportPurchaseJobStatus> pollJob(
    String jobId, {
    bool compactLog = false,
  }) async {
    final uri = Uri.parse('${_base}imports-purchases/jobs/$jobId');
    final response = await _get(
      uri,
      label: 'poll job',
      compactLog: compactLog,
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Import/purchase job poll failed (${response.statusCode}): ${response.body}',
      );
    }
    final decoded = _decodeJsonObject(response);
    final job = decoded['job'] as Map<String, dynamic>?;
    return ImportPurchaseJobStatus(
      jobId: decoded['jobId'] as String? ?? jobId,
      operation: decoded['operation'] as String? ?? job?['operation'] as String?,
      status: decoded['status'] as String? ?? job?['status'] as String? ?? 'unknown',
      error: decoded['error'] as String? ?? job?['error'] as String?,
      resultMsg: decoded['resultMsg'] as String? ?? job?['resultMsg'] as String?,
      resultCd: decoded['resultCd'] as String? ?? job?['resultCd'] as String?,
      fetched: _asInt(decoded['fetched'] ?? job?['fetched']),
      steps: _parseSteps(decoded['steps'] ?? job?['steps']),
      job: job,
    );
  }

  Future<ImportPurchaseJobStatus> pollJobUntilTerminal(
    String jobId, {
    Duration interval = const Duration(seconds: 1),
    Duration timeout = const Duration(minutes: 5),
  }) async {
    final deadline = DateTime.now().add(timeout);
    var pollCount = 0;
    while (DateTime.now().isBefore(deadline)) {
      final compact = pollCount > 0;
      final status = await pollJob(jobId, compactLog: compact);
      pollCount++;
      if (status.isTerminal) {
        if (compact && logHttp) {
          DataConnectorHttpLog.response(
            method: 'GET',
            uri: Uri.parse('${_base}imports-purchases/jobs/$jobId'),
            statusCode: 200,
            operation: 'poll job (terminal)',
            body: jsonEncode({
              'jobId': status.jobId,
              'status': status.status,
              'resultCd': status.resultCd,
              'resultMsg': status.resultMsg,
              'error': status.error,
              'fetched': status.fetched,
              'steps': status.steps
                  .map(
                    (s) => {
                      'step': s.step,
                      'resultCd': s.resultCd,
                      'resultMsg': s.resultMsg,
                    },
                  )
                  .toList(),
            }),
          );
        }
        return status;
      }
      await Future<void>.delayed(interval);
    }
    throw TimeoutException(
      'Import/purchase job $jobId did not finish within ${timeout.inSeconds}s',
    );
  }

  Future<ImportPurchaseJobAccepted> _postJob(
    String url,
    Map<String, dynamic> body, {
    required String label,
  }) async {
    final uri = Uri.parse(url);
    final encoded = jsonEncode(body);
    final response = await _post(uri, body: encoded, label: label);
    if (response.statusCode != 202) {
      throw Exception(
        'Import/purchase request failed (${response.statusCode}): ${response.body}',
      );
    }
    final decoded = _decodeJsonObject(response);
    return ImportPurchaseJobAccepted(
      jobId: decoded['jobId'] as String,
      operation: decoded['operation'] as String? ?? '',
      status: decoded['status'] as String? ?? 'queued',
    );
  }

  Future<http.Response> _get(
    Uri uri, {
    required String label,
    bool compactLog = false,
  }) async {
    if (logHttp) {
      DataConnectorHttpLog.request(method: 'GET', uri: uri, operation: label);
    }
    final started = Stopwatch()..start();
    final response = await _http.get(uri);
    started.stop();
    if (logHttp) {
      DataConnectorHttpLog.response(
        method: 'GET',
        uri: uri,
        statusCode: response.statusCode,
        body: response.body,
        elapsed: started.elapsed,
        compact: compactLog,
        operation: label,
      );
    }
    return response;
  }

  Future<http.Response> _post(
    Uri uri, {
    required String body,
    required String label,
  }) async {
    if (logHttp) {
      DataConnectorHttpLog.request(
        method: 'POST',
        uri: uri,
        body: body,
        headers: _jsonHeaders,
        operation: label,
      );
    }
    final started = Stopwatch()..start();
    final response = await _http.post(uri, headers: _jsonHeaders, body: body);
    started.stop();
    if (logHttp) {
      DataConnectorHttpLog.response(
        method: 'POST',
        uri: uri,
        statusCode: response.statusCode,
        body: response.body,
        elapsed: started.elapsed,
        operation: label,
      );
    }
    return response;
  }

  String _listQuery({
    required String branchId,
    String? status,
    int? limit,
  }) {
    final params = <String, String>{'branchId': branchId};
    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }
    if (limit != null) {
      params['limit'] = limit.toString();
    }
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
        )
        .join('&');
  }

  void _ensureOk(http.Response response, String action) {
    if (response.statusCode != 200) {
      throw ImportsPurchasesApiException(
        statusCode: response.statusCode,
        action: action,
        body: response.body,
      );
    }
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static List<ImportPurchaseJobStep> _parseSteps(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (e) => ImportPurchaseJobStep(
            step: e['step']?.toString(),
            resultCd: e['resultCd']?.toString(),
            resultMsg: e['resultMsg']?.toString(),
          ),
        )
        .toList();
  }
}

class ImportsPurchasesApiException implements Exception {
  ImportsPurchasesApiException({
    required this.statusCode,
    required this.action,
    required this.body,
  });

  final int statusCode;
  final String action;
  final String body;

  bool get isNotFound => statusCode == 404;

  @override
  String toString() => 'Failed to $action ($statusCode): $body';
}

class ImportPurchaseJobAccepted {
  ImportPurchaseJobAccepted({
    required this.jobId,
    required this.operation,
    required this.status,
  });

  final String jobId;
  final String operation;
  final String status;
}

class ImportPurchaseJobStep {
  const ImportPurchaseJobStep({this.step, this.resultCd, this.resultMsg});

  final String? step;
  final String? resultCd;
  final String? resultMsg;
}

class ImportPurchaseJobStatus {
  ImportPurchaseJobStatus({
    required this.jobId,
    required this.status,
    this.operation,
    this.error,
    this.resultMsg,
    this.resultCd,
    this.fetched,
    this.steps = const [],
    this.job,
  });

  final String jobId;
  final String? operation;
  final String status;
  final String? error;
  final String? resultMsg;
  final String? resultCd;
  final int? fetched;
  final List<ImportPurchaseJobStep> steps;
  final Map<String, dynamic>? job;

  bool get isSuccess => status == 'success';

  bool get isFailed => status == 'failed';

  bool get isTerminal => isSuccess || isFailed;
}

/// Builds [ImportPurchaseContext] from branch/business/EBM fields.
ImportPurchaseContext buildImportPurchaseContext({
  required int tinNumber,
  required String branchId,
  required String businessId,
  String? bhfId,
  String? taxServerUrl,
  bool vatEnabled = true,
}) {
  return ImportPurchaseContext(
    tinNumber: tinNumber.toString(),
    bhfId: bhfId ?? '00',
    branchId: branchId,
    businessId: businessId,
    taxServerUrl: taxServerUrl,
    vatEnabled: vatEnabled,
  );
}

/// Resolves data-connector base URL from EBM config.
Future<String> resolveImportsPurchasesBaseUrl({
  String? dataConnectorUrl,
}) async {
  final configured = dataConnectorUrl?.trim();
  if (configured != null && configured.isNotEmpty) {
    return configured.endsWith('/') ? configured : '$configured/';
  }
  return 'http://127.0.0.1:8084/';
}

/// Resolves connector client from EBM config.
Future<ImportsPurchasesClient> createImportsPurchasesClient({
  String? dataConnectorUrl,
  http.Client? httpClient,
  bool logHttp = true,
}) async {
  final base = await resolveImportsPurchasesBaseUrl(
    dataConnectorUrl: dataConnectorUrl,
  );
  return ImportsPurchasesClient(
    baseUrl: base,
    httpClient: httpClient,
    logHttp: logHttp,
  );
}

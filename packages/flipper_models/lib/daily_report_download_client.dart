import 'dart:convert';
import 'dart:io';

import 'package:flipper_models/bulk_rra_client.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Response from data-connector `GET /reports/daily-files/download`.
class DailyReportPresignResponse {
  DailyReportPresignResponse({
    required this.downloadUrl,
    required this.expiresInSeconds,
    required this.fileName,
  });

  final String downloadUrl;
  final int expiresInSeconds;
  final String fileName;

  factory DailyReportPresignResponse.fromJson(Map<String, dynamic> json) {
    return DailyReportPresignResponse(
      downloadUrl: json['downloadUrl'] as String,
      expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 0,
      fileName: json['fileName'] as String? ?? 'daily-report.xlsx',
    );
  }
}

class DailyReportPreviewResponse {
  DailyReportPreviewResponse({
    required this.fileName,
    required this.fileId,
    required this.sheetName,
    required this.format,
    required this.sizeBytes,
    required this.rows,
    required this.columns,
    required this.previewRows,
  });

  final String fileName;
  final String fileId;
  final String sheetName;
  final String format;
  final int sizeBytes;
  final int rows;
  final int columns;
  final List<List<String>> previewRows;

  factory DailyReportPreviewResponse.fromJson(Map<String, dynamic> json) {
    final rawRows = json['previewRows'] as List? ?? const [];
    return DailyReportPreviewResponse(
      fileName: json['fileName'] as String? ?? 'daily-report.xlsx',
      fileId: json['fileId'] as String? ?? '',
      sheetName: json['sheetName'] as String? ?? 'Report',
      format: json['format'] as String? ?? 'XLSX · v2007+',
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      rows: (json['rows'] as num?)?.toInt() ?? 0,
      columns: (json['columns'] as num?)?.toInt() ?? 0,
      previewRows: rawRows
          .map(
            (row) => (row as List? ?? const [])
                .map((cell) => cell?.toString() ?? '')
                .toList(growable: false),
          )
          .toList(growable: false),
    );
  }
}

Future<DailyReportPresignResponse> fetchDailyReportPresign({
  required String branchId,
  required String objectKey,
  required String dataConnectorBaseUrl,
}) async {
  final trimmed = dataConnectorBaseUrl.trim();
  final base = trimmed.endsWith('/') ? trimmed : '$trimmed/';
  final uri = Uri.parse(
    '${base}reports/daily-files/download',
  ).replace(queryParameters: {'branchId': branchId, 'objectKey': objectKey});

  final res = await http.get(uri);
  if (res.statusCode >= 400) {
    Map<String, dynamic>? err;
    try {
      err = json.decode(res.body) as Map<String, dynamic>?;
    } catch (_) {}
    final msg = err?['error'] as String? ?? res.body;
    throw DailyReportDownloadException(
      'Presign failed (${res.statusCode}): $msg',
    );
  }
  try {
    final map = json.decode(res.body) as Map<String, dynamic>;
    return DailyReportPresignResponse.fromJson(map);
  } catch (e) {
    throw DailyReportDownloadException('Invalid presign response: $e');
  }
}

Future<DailyReportPreviewResponse> fetchDailyReportPreview({
  required String branchId,
  required String objectKey,
  required String dataConnectorBaseUrl,
}) async {
  final trimmed = dataConnectorBaseUrl.trim();
  final base = trimmed.endsWith('/') ? trimmed : '$trimmed/';
  final uri = Uri.parse(
    '${base}reports/daily-files/preview',
  ).replace(queryParameters: {'branchId': branchId, 'objectKey': objectKey});

  final res = await http.get(uri);
  if (res.statusCode >= 400) {
    Map<String, dynamic>? err;
    try {
      err = json.decode(res.body) as Map<String, dynamic>?;
    } catch (_) {}
    final msg = err?['error'] as String? ?? res.body;
    throw DailyReportDownloadException(
      'Preview failed (${res.statusCode}): $msg',
    );
  }
  try {
    final map = json.decode(res.body) as Map<String, dynamic>;
    return DailyReportPreviewResponse.fromJson(map);
  } catch (e) {
    throw DailyReportDownloadException('Invalid preview response: $e');
  }
}

class DailyReportArchiveResponse {
  DailyReportArchiveResponse({required this.archivedCount});

  final int archivedCount;

  factory DailyReportArchiveResponse.fromJson(Map<String, dynamic> json) {
    return DailyReportArchiveResponse(
      archivedCount: (json['archivedCount'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Soft-archives catalogue rows on data-connector (Ditto `archivedAt`).
Future<DailyReportArchiveResponse> archiveDailyReportFilesRemote({
  required String branchId,
  required List<String> objectKeys,
  required String dataConnectorBaseUrl,
}) async {
  final keys = objectKeys
      .map((k) => k.trim())
      .where((k) => k.isNotEmpty)
      .toSet()
      .toList(growable: false);
  if (keys.isEmpty) {
    return DailyReportArchiveResponse(archivedCount: 0);
  }

  final trimmed = dataConnectorBaseUrl.trim();
  final base = trimmed.endsWith('/') ? trimmed : '$trimmed/';
  final uri = Uri.parse('${base}reports/daily-files/archive');

  final res = await http.post(
    uri,
    headers: const {'content-type': 'application/json'},
    body: json.encode({'branchId': branchId, 'objectKeys': keys}),
  );
  if (res.statusCode >= 400) {
    Map<String, dynamic>? err;
    try {
      err = json.decode(res.body) as Map<String, dynamic>?;
    } catch (_) {}
    final msg = err?['error'] as String? ?? res.body;
    throw DailyReportDownloadException(
      'Archive failed (${res.statusCode}): $msg',
    );
  }
  try {
    final map = json.decode(res.body) as Map<String, dynamic>;
    return DailyReportArchiveResponse.fromJson(map);
  } catch (e) {
    throw DailyReportDownloadException('Invalid archive response: $e');
  }
}

Future<DailyReportArchiveResponse> archiveDailyReportFilesViaDataConnector({
  required String branchId,
  required List<String> objectKeys,
  String? dataConnectorUrl,
}) async {
  final base = await resolveDataConnectorBaseUrl(
    dataConnectorUrl: dataConnectorUrl,
  );
  return archiveDailyReportFilesRemote(
    branchId: branchId,
    objectKeys: objectKeys,
    dataConnectorBaseUrl: base,
  );
}

Future<DailyReportPresignResponse> mergeDailyReportExcels({
  required String branchId,
  required List<String> objectKeys,
  required String dataConnectorBaseUrl,
}) async {
  final trimmed = dataConnectorBaseUrl.trim();
  final base = trimmed.endsWith('/') ? trimmed : '$trimmed/';
  final uri = Uri.parse('${base}reports/daily-files/merge');

  final res = await http.post(
    uri,
    headers: const {'content-type': 'application/json'},
    body: json.encode({'branchId': branchId, 'objectKeys': objectKeys}),
  );
  if (res.statusCode >= 400) {
    Map<String, dynamic>? err;
    try {
      err = json.decode(res.body) as Map<String, dynamic>?;
    } catch (_) {}
    final msg = err?['error'] as String? ?? res.body;
    throw DailyReportDownloadException(
      'Merge failed (${res.statusCode}): $msg',
    );
  }
  try {
    final map = json.decode(res.body) as Map<String, dynamic>;
    return DailyReportPresignResponse.fromJson(map);
  } catch (e) {
    throw DailyReportDownloadException('Invalid merge response: $e');
  }
}

/// Saves under app support directory (creates unique name if needed). Returns saved path.
Future<String> saveDailyReportFromPresignedUrl(
  DailyReportPresignResponse presign,
) async {
  final dl = await http.get(Uri.parse(presign.downloadUrl));
  if (dl.statusCode >= 400) {
    throw DailyReportDownloadException('Download failed (${dl.statusCode})');
  }

  final dir = await getApplicationSupportDirectory();
  var fileName = presign.fileName.replaceAll(RegExp(r'[^\w.-]+'), '_');
  if (!fileName.toLowerCase().endsWith('.xlsx')) {
    fileName = '$fileName.xlsx';
  }

  var path = p.join(dir.path, fileName);
  var n = 0;
  while (await File(path).exists()) {
    n++;
    final dotIdx = fileName.lastIndexOf('.');
    final stem = dotIdx > 0 ? fileName.substring(0, dotIdx) : fileName;
    final ext = dotIdx > 0 ? fileName.substring(dotIdx) : '.xlsx';
    path = p.join(dir.path, '${stem}_$n$ext');
  }

  await File(path).writeAsBytes(dl.bodyBytes);
  return path;
}

Future<void> openDailyReportWithSystemViewer(String savedPath) async {
  await OpenFilex.open(savedPath);
}

Future<String> downloadDailyReportExcel({
  required String branchId,
  required String objectKey,
  String? dataConnectorUrl,
  bool openAfterSave = true,
}) async {
  if (kIsWeb) {
    throw DailyReportDownloadException(
      'Daily report download is not supported in the browser.',
    );
  }
  final base = await resolveDataConnectorBaseUrl(
    dataConnectorUrl: dataConnectorUrl,
  );
  final presign = await fetchDailyReportPresign(
    branchId: branchId,
    objectKey: objectKey,
    dataConnectorBaseUrl: base,
  );
  final savedPath = await saveDailyReportFromPresignedUrl(presign);
  if (openAfterSave) {
    await openDailyReportWithSystemViewer(savedPath);
  }
  return savedPath;
}

Future<DailyReportPreviewResponse> previewDailyReportExcel({
  required String branchId,
  required String objectKey,
  String? dataConnectorUrl,
}) async {
  final base = await resolveDataConnectorBaseUrl(
    dataConnectorUrl: dataConnectorUrl,
  );
  return fetchDailyReportPreview(
    branchId: branchId,
    objectKey: objectKey,
    dataConnectorBaseUrl: base,
  );
}

Future<DailyReportPresignResponse> createMergedDailyReportExcel({
  required String branchId,
  required List<String> objectKeys,
  String? dataConnectorUrl,
}) async {
  if (objectKeys.length < 2) {
    throw DailyReportDownloadException(
      'Select at least two daily report files to merge.',
    );
  }
  final base = await resolveDataConnectorBaseUrl(
    dataConnectorUrl: dataConnectorUrl,
  );
  return mergeDailyReportExcels(
    branchId: branchId,
    objectKeys: objectKeys,
    dataConnectorBaseUrl: base,
  );
}

Future<String> mergeAndDownloadDailyReportExcels({
  required String branchId,
  required List<String> objectKeys,
  String? dataConnectorUrl,
  bool openAfterSave = true,
}) async {
  if (kIsWeb) {
    throw DailyReportDownloadException(
      'Daily report merge is not supported in the browser.',
    );
  }
  if (objectKeys.length < 2) {
    throw DailyReportDownloadException(
      'Select at least two daily report files to merge.',
    );
  }
  final base = await resolveDataConnectorBaseUrl(
    dataConnectorUrl: dataConnectorUrl,
  );
  final presign = await mergeDailyReportExcels(
    branchId: branchId,
    objectKeys: objectKeys,
    dataConnectorBaseUrl: base,
  );
  final savedPath = await saveDailyReportFromPresignedUrl(presign);
  if (openAfterSave) {
    await openDailyReportWithSystemViewer(savedPath);
  }
  return savedPath;
}

class DailyReportDownloadException implements Exception {
  DailyReportDownloadException(this.message);

  final String message;

  @override
  String toString() => message;
}

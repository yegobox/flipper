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

Future<DailyReportPresignResponse> fetchDailyReportPresign({
  required String branchId,
  required String objectKey,
  required String dataConnectorBaseUrl,
}) async {
  final trimmed = dataConnectorBaseUrl.trim();
  final base = trimmed.endsWith('/') ? trimmed : '$trimmed/';
  final uri =
      Uri.parse('${base}reports/daily-files/download').replace(
        queryParameters: {
          'branchId': branchId,
          'objectKey': objectKey,
        },
      );

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

/// Saves under app support directory (creates unique name if needed). Returns saved path.
Future<String> saveDailyReportFromPresignedUrl(
  DailyReportPresignResponse presign,
) async {
  final dl = await http.get(Uri.parse(presign.downloadUrl));
  if (dl.statusCode >= 400) {
    throw DailyReportDownloadException(
      'Download failed (${dl.statusCode})',
    );
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
    final stem =
        dotIdx > 0 ? fileName.substring(0, dotIdx) : fileName;
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
  final base =
      await resolveDataConnectorBaseUrl(dataConnectorUrl: dataConnectorUrl);
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

class DailyReportDownloadException implements Exception {
  DailyReportDownloadException(this.message);

  final String message;

  @override
  String toString() => message;
}

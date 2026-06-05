import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

/// Resolved receipt PDF bytes from local disk or S3 (no new RRA request).
class StoredReceipt {
  const StoredReceipt({
    required this.bytes,
    this.localPath,
  });

  final Uint8List bytes;
  final String? localPath;
}

/// Loads a receipt PDF already generated at sale time.
class StoredReceiptLoader {
  static const _pendingUploadsKey = 'pending_receipt_uploads';

  Future<StoredReceipt?> load(ITransaction transaction) async {
    final receiptFileName = transaction.receiptFileName?.trim();
    if (receiptFileName == null || receiptFileName.isEmpty) {
      return null;
    }

    final fromLocal = await _loadFromDocuments(receiptFileName);
    if (fromLocal != null) return fromLocal;

    final fromPending = await _loadFromPendingQueue(
      transactionId: transaction.id,
      receiptFileName: receiptFileName,
    );
    if (fromPending != null) return fromPending;

    final branchId = transaction.branchId ?? ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) return null;

    return _downloadFromS3(
      branchId: branchId,
      receiptFileName: receiptFileName,
    );
  }

  Future<StoredReceipt?> _loadFromDocuments(String receiptFileName) async {
    if (receiptFileName.isEmpty) return null;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$receiptFileName';
      final file = File(path);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return null;
      return StoredReceipt(bytes: bytes, localPath: path);
    } catch (_) {
      return null;
    }
  }

  Future<StoredReceipt?> _loadFromPendingQueue({
    required String transactionId,
    required String receiptFileName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_pendingUploadsKey);
      if (raw == null || raw.isEmpty) return null;

      final list = jsonDecode(raw) as List<dynamic>;
      for (final entry in list) {
        if (entry is! Map) continue;
        final map = Map<String, dynamic>.from(entry);
        if (map['transactionId']?.toString() != transactionId) continue;

        final localPath = map['localPath']?.toString() ?? '';
        if (localPath.isEmpty) continue;

        final file = File(localPath);
        if (!await file.exists()) continue;

        final bytes = await file.readAsBytes();
        if (bytes.isEmpty) continue;
        return StoredReceipt(bytes: bytes, localPath: localPath);
      }

      // Filename match when transaction id differs (legacy queue entries).
      for (final entry in list) {
        if (entry is! Map) continue;
        final map = Map<String, dynamic>.from(entry);
        final fileName = map['fileName']?.toString() ?? '';
        if (!receiptFileName.startsWith(fileName) && fileName.isNotEmpty) {
          continue;
        }
        final localPath = map['localPath']?.toString() ?? '';
        if (localPath.isEmpty) continue;
        final file = File(localPath);
        if (!await file.exists()) continue;
        final bytes = await file.readAsBytes();
        if (bytes.isEmpty) continue;
        return StoredReceipt(bytes: bytes, localPath: localPath);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<StoredReceipt?> _downloadFromS3({
    required String branchId,
    required String receiptFileName,
  }) async {
    try {
      final storagePath = StoragePath.fromString(
        'public/invoices-$branchId/$receiptFileName',
      );
      final tempDir = await getTemporaryDirectory();
      final localPath = '${tempDir.path}/$receiptFileName';
      final localFile = AWSFile.fromPath(localPath);

      await Amplify.Storage.downloadFile(
        path: storagePath,
        localFile: localFile,
      ).result;

      final file = File(localPath);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return null;
      return StoredReceipt(bytes: bytes, localPath: localPath);
    } catch (_) {
      return null;
    }
  }
}

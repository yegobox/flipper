import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_services/digital_receipt_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Queues receipt PDF uploads when offline and retries when connectivity returns.
class ReceiptSyncService {
  static final ReceiptSyncService _instance = ReceiptSyncService._internal();
  factory ReceiptSyncService() => _instance;

  ReceiptSyncService._internal();

  static const _prefsKey = 'pending_receipt_uploads';

  final talker = TalkerFlutter.init();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _syncTimer;
  bool _isSyncing = false;

  /// True for Amplify [NetworkException], [SocketException], and DNS failures.
  static bool isUploadNetworkError(Object error) {
    if (error is SocketException) return true;
    final message = error.toString();
    return message.contains('NetworkException') ||
        message.contains('SocketException') ||
        message.contains('Failed host lookup') ||
        message.contains('network error');
  }

  void initialize() {
    talker.info('ReceiptSyncService: Initializing');

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_handleConnectivityChange);

    Connectivity().checkConnectivity().then(_handleConnectivityChange);

    _syncTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      unawaited(syncPendingUploads());
    });

    unawaited(syncPendingUploads());
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasConnection =
        results.any((result) => result != ConnectivityResult.none);
    if (hasConnection) {
      talker.info(
        'ReceiptSyncService: Connectivity restored, checking pending uploads',
      );
      unawaited(syncPendingUploads());
    }
  }

  Future<void> queuePendingUpload({
    required String transactionId,
    required String fileName,
    required String localPath,
    bool sendSmsAfterUpload = false,
  }) async {
    if (transactionId.isEmpty || fileName.isEmpty || localPath.isEmpty) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final pending = _readPending(prefs);

      final index = pending.indexWhere(
        (entry) => entry.transactionId == transactionId,
      );

      final entry = PendingReceiptUpload(
        transactionId: transactionId,
        fileName: fileName,
        localPath: localPath,
        sendSmsAfterUpload: sendSmsAfterUpload,
      );

      if (index >= 0) {
        pending[index] = entry;
      } else {
        pending.add(entry);
      }

      await _writePending(prefs, pending);
      talker.info(
        'ReceiptSyncService: Queued receipt upload for transaction $transactionId',
      );
    } catch (e, s) {
      talker.error('ReceiptSyncService: Failed to queue upload: $e', e, s);
    }
  }

  Future<bool> hasPendingUploads() async {
    final prefs = await SharedPreferences.getInstance();
    return _readPending(prefs).isNotEmpty;
  }

  Future<void> syncPendingUploads() async {
    if (_isSyncing) {
      talker.info('ReceiptSyncService: Sync already in progress, skipping');
      return;
    }

    _isSyncing = true;
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      final hasConnection = connectivityResults
          .any((result) => result != ConnectivityResult.none);
      if (!hasConnection) return;

      final prefs = await SharedPreferences.getInstance();
      final pending = _readPending(prefs);
      if (pending.isEmpty) return;

      talker.info(
        'ReceiptSyncService: Uploading ${pending.length} pending receipt(s)',
      );

      final remaining = <PendingReceiptUpload>[];

      for (final entry in pending) {
        final uploaded = await _uploadEntry(entry);
        if (!uploaded) {
          remaining.add(entry);
        }
      }

      await _writePending(prefs, remaining);

      if (remaining.isEmpty) {
        talker.info('ReceiptSyncService: All pending receipts uploaded');
      } else {
        talker.warning(
          'ReceiptSyncService: ${remaining.length} receipt(s) still pending',
        );
      }
    } catch (e, s) {
      talker.error('ReceiptSyncService: Sync failed: $e', e, s);
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _uploadEntry(PendingReceiptUpload entry) async {
    try {
      final file = File(entry.localPath);
      if (!await file.exists()) {
        talker.warning(
          'ReceiptSyncService: Local file missing for ${entry.transactionId}: '
          '${entry.localPath}',
        );
        return true;
      }

      if (entry.sendSmsAfterUpload) {
        await DigitalReceiptService.queueSmsAfterReceiptUpload(
          entry.transactionId,
        );
      }

      final pdfData = await file.readAsBytes();
      await ProxyService.strategy.uploadPdfToS3(
        pdfData,
        entry.fileName,
        transactionId: entry.transactionId,
      );

      talker.info(
        'ReceiptSyncService: Uploaded receipt for ${entry.transactionId}',
      );
      return true;
    } catch (e, s) {
      if (isUploadNetworkError(e)) {
        talker.warning(
          'ReceiptSyncService: Still offline for ${entry.transactionId}: $e',
        );
      } else {
        talker.error(
          'ReceiptSyncService: Upload failed for ${entry.transactionId}: $e',
          e,
          s,
        );
      }
      return false;
    }
  }

  List<PendingReceiptUpload> _readPending(SharedPreferences prefs) {
    final raw = prefs.getStringList(_prefsKey) ?? [];
    return raw
        .map((item) {
          try {
            return PendingReceiptUpload.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<PendingReceiptUpload>()
        .toList();
  }

  Future<void> _writePending(
    SharedPreferences prefs,
    List<PendingReceiptUpload> pending,
  ) async {
    await prefs.setStringList(
      _prefsKey,
      pending.map((entry) => jsonEncode(entry.toJson())).toList(),
    );
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
  }
}

class PendingReceiptUpload {
  const PendingReceiptUpload({
    required this.transactionId,
    required this.fileName,
    required this.localPath,
    this.sendSmsAfterUpload = false,
  });

  final String transactionId;
  final String fileName;
  final String localPath;
  final bool sendSmsAfterUpload;

  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'fileName': fileName,
        'localPath': localPath,
        'sendSmsAfterUpload': sendSmsAfterUpload,
      };

  factory PendingReceiptUpload.fromJson(Map<String, dynamic> json) {
    return PendingReceiptUpload(
      transactionId: json['transactionId'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      localPath: json['localPath'] as String? ?? '',
      sendSmsAfterUpload: json['sendSmsAfterUpload'] as bool? ?? false,
    );
  }
}

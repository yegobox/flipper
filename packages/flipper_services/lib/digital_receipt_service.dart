import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Queues and invokes [generateReceiptUrl] after a receipt PDF is in S3.
/// Transaction flags live in Ditto; Supabase only stores short URLs + SMS outbox.
class DigitalReceiptService {
  DigitalReceiptService._();

  static const _functionName = 'generateReceiptUrl';
  static String _pendingKey(String transactionId) =>
      'pending_digital_receipt_$transactionId';

  /// Call when the user confirms they want a digital receipt (before/at print).
  static Future<void> queueSmsAfterReceiptUpload(String transactionId) async {
    if (transactionId.isEmpty) return;
    await ProxyService.box.writeBool(
      key: _pendingKey(transactionId),
      value: true,
    );
  }

  static bool _consumePending(String transactionId) {
    final key = _pendingKey(transactionId);
    if (ProxyService.box.readBool(key: key) != true) return false;
    ProxyService.box.writeBool(key: key, value: false);
    return true;
  }

  /// After [uploadPdfToS3], sends SMS link if the user opted in and not already sent.
  static Future<void> maybeSendAfterUpload({
    required String transactionId,
    required String branchId,
    required String receiptFileName,
    String? customerPhone,
    String? alternatePhone,
    bool? alreadySent,
  }) async {
    if (!_consumePending(transactionId)) return;
    if (alreadySent == true) return;

    final phone = _firstNonEmpty(customerPhone, alternatePhone);
    if (phone == null) {
      talker.debug(
        'digital receipt: skip — no phone for transaction $transactionId',
      );
      return;
    }

    final shortUrlId = await requestReceiptLink(
      branchId: branchId,
      receiptFileName: receiptFileName,
      phoneNumber: phone,
      transactionId: transactionId,
    );

    if (shortUrlId == null) return;

    try {
      final strategy = ProxyService.getStrategy(Strategy.capella);
      final tx = await strategy.getTransaction(
        id: transactionId,
        branchId: branchId,
      );
      if (tx == null) return;
      tx.isDigitalReceiptGenerated = true;
      await strategy.updateTransaction(
        transaction: tx,
        transactionId: transactionId,
      );
    } catch (e, s) {
      talker.debug('digital receipt: Ditto flag update failed: $e\n$s');
    }
  }

  static String? _firstNonEmpty(String? a, String? b) {
    if (a != null && a.trim().isNotEmpty) return a.trim();
    if (b != null && b.trim().isNotEmpty) return b.trim();
    return null;
  }

  /// Returns short URL id on success.
  static Future<String?> requestReceiptLink({
    required String branchId,
    required String receiptFileName,
    required String phoneNumber,
    String? transactionId,
    bool sendSms = true,
  }) async {
    if (branchId.isEmpty || receiptFileName.isEmpty) return null;

    try {
      final response = await Supabase.instance.client.functions.invoke(
        _functionName,
        body: {
          'branchId': branchId,
          'imageInS3': receiptFileName,
          'phone': phoneNumber,
          'sendSms': sendSms,
          if (transactionId != null && transactionId.isNotEmpty)
            'transactionId': transactionId,
        },
      );

      if (response.status != 200) {
        talker.debug(
          'digital receipt invoke failed (${response.status}): ${response.data}',
        );
        return null;
      }

      final data = response.data;
      if (data is Map && data['url'] != null) {
        return data['url'].toString();
      }
      return null;
    } catch (e, s) {
      talker.debug('digital receipt invoke error: $e\n$s');
      return null;
    }
  }
}

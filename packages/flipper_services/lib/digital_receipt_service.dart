import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/supabase_session_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Queues and invokes [generateReceiptUrl] after a receipt PDF is in S3.
class DigitalReceiptService {
  DigitalReceiptService._();

  static const _functionName = 'generateReceiptUrl';
  static String _pendingKey(String transactionId) =>
      'pending_digital_receipt_$transactionId';

  static Future<void> queueSmsAfterReceiptUpload(String transactionId) async {
    if (transactionId.isEmpty) return;
    await ProxyService.box.writeBool(
      key: _pendingKey(transactionId),
      value: true,
    );
    talker.info('digital receipt: queued SMS for transaction $transactionId');
  }



  static Future<void> maybeSendAfterUpload({
    required String transactionId,
    required String branchId,
    required String receiptFileName,
    String? customerPhone,
    String? alternatePhone,
    bool? alreadySent,
  }) async {
    talker.info(
      'digital receipt: maybeSendAfterUpload tx=$transactionId file=$receiptFileName',
    );

    // 
    if (alreadySent == true) {
      talker.warning(
        'digital receipt: skipped — already sent for $transactionId',
      );
      return;
    }

    final phone = _firstNonEmpty(customerPhone, alternatePhone);
    if (phone == null) {
      talker.warning(
        'digital receipt: skipped — no customerPhone on transaction $transactionId',
      );
      return;
    }

    final smsBranchId = await _resolveSmsBranchId(branchId);
    if (smsBranchId == null) {
      talker.warning(
        'digital receipt: skipped — branch $branchId has no serverId for SMS credits',
      );
      return;
    }

    final shortUrlId = await requestReceiptLink(
      branchId: branchId,
      receiptFileName: receiptFileName,
      phoneNumber: phone,
      transactionId: transactionId,
      smsBranchId: smsBranchId,
    );

    if (shortUrlId == null) {
      talker.warning(
        'digital receipt: generateReceiptUrl failed for $transactionId',
      );
      return;
    }

    talker.info(
      'digital receipt: short link $shortUrlId queued — run sendSms to deliver',
    );

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
      talker.warning('digital receipt: Ditto flag update failed: $e\n$s');
    }
  }

  static Future<int?> _resolveSmsBranchId(String branchId) async {
    try {
      final branch = await ProxyService.getStrategy(
        Strategy.capella,
      ).branch(serverId: branchId);
      final serverId = branch?.serverId;
      if (serverId != null && serverId > 0) return serverId;
    } catch (e) {
      talker.debug('digital receipt: branch lookup failed: $e');
    }
    final parsed = int.tryParse(branchId);
    return parsed != null && parsed > 0 ? parsed : null;
  }

  static String? _firstNonEmpty(String? a, String? b) {
    if (a != null && a.trim().isNotEmpty) return a.trim();
    if (b != null && b.trim().isNotEmpty) return b.trim();
    return null;
  }

  static Future<String?> requestReceiptLink({
    required String branchId,
    required String receiptFileName,
    required String phoneNumber,
    String? transactionId,
    int? smsBranchId,
    bool sendSms = true,
  }) async {
    if (branchId.isEmpty || receiptFileName.isEmpty) return null;

    final token = await SupabaseSessionService.ensureAccessToken();
    if (token == null) {
      final userPhone = ProxyService.box.getUserPhone();
      talker.warning(
        'digital receipt: no Supabase session '
        '(expected ${userPhone != null ? SupabaseSessionService.emailFromPhone(userPhone) : "phone@flipper.rw"})',
      );
      return null;
    }

    try {
      final response = await Supabase.instance.client.functions.invoke(
        _functionName,
        body: {
          'branchId': branchId,
          'imageInS3': receiptFileName,
          'phone': phoneNumber,
          'sendSms': sendSms,
          if (smsBranchId != null) 'smsBranchId': smsBranchId,
          if (transactionId != null && transactionId.isNotEmpty)
            'transactionId': transactionId,
        },
        headers: await SupabaseSessionService.edgeFunctionAuthHeaders(),
      );

      final data = response.data;
      talker.info(
        'digital receipt: generateReceiptUrl status=${response.status} data=$data',
      );

      if (response.status == 401) {
        talker.warning(
          'digital receipt: 401 — Supabase JWT rejected. '
          'Confirm edge function has verify_jwt enabled and user exists as '
          '{phoneDigits}@flipper.rw',
        );
        return null;
      }

      if (response.status != 200) return null;

      if (data is Map) {
        if (data['sms_queued'] != true && data['sms_skip_reason'] != null) {
          talker.warning(
            'digital receipt: SMS not queued: ${data['sms_skip_reason']}',
          );
        }
        if (data['url'] != null) return data['url'].toString();
      }
      return null;
    } catch (e, s) {
      talker.warning('digital receipt invoke error: $e\n$s');
      return null;
    }
  }
}

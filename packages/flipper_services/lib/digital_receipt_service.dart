import 'dart:convert';

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

    final rawPhone = _firstNonEmpty(customerPhone, alternatePhone);
    if (rawPhone == null) {
      talker.warning(
        'digital receipt: skipped — no customerPhone on transaction $transactionId',
      );
      return;
    }

    final phone = _normalizePhoneForSms(rawPhone);
    if (phone == null) {
      talker.warning(
        'digital receipt: skipped — invalid phone "$rawPhone" on $transactionId',
      );
      return;
    }
    if (phone != rawPhone.replaceAll(RegExp(r'\D'), '')) {
      talker.debug('digital receipt: normalized phone $rawPhone → $phone');
    }

    final smsBranchId = await _resolveSmsBranchId(branchId);
    if (smsBranchId == null) {
      talker.warning(
        'digital receipt: skipped — branch $branchId has no serverId for SMS credits',
      );
      return;
    }

    final result = await requestReceiptLink(
      branchId: branchId,
      receiptFileName: receiptFileName,
      phoneNumber: phone,
      transactionId: transactionId,
      smsBranchId: smsBranchId,
    );

    if (result == null) {
      talker.warning(
        'digital receipt: generateReceiptUrl failed for $transactionId',
      );
      return;
    }

    final shortUrlId = result.shortUrlId;
    talker.info(
      'digital receipt: short link $shortUrlId queued — '
      'message_id=${result.messageId ?? "n/a"} '
      '(Supabase messages table; run sendSms to deliver)',
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

  /// MSISDN with Rwanda country code for `messages.phone_number` (e.g. 250783054874).
  /// this will not work when app is working internationally fix this ASAP.
  static String? _normalizePhoneForSms(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) return null;

    if (digitsOnly.startsWith('0')) {
      final normalized = '250${digitsOnly.substring(1)}';
      return normalized.length >= 12 ? normalized : null;
    }

    if (digitsOnly.length == 9) {
      return '250$digitsOnly';
    }

    if (digitsOnly.startsWith('250') && digitsOnly.length >= 12) {
      return digitsOnly;
    }

    return digitsOnly.length >= 10 ? digitsOnly : null;
  }

  static Map<String, dynamic>? _parseResponseData(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }

  /// When the deployed edge build omits [message_id], resolve the row we just queued.
  static Future<String?> _lookupQueuedMessageId({
    required String phoneNumber,
    required String shortUrlId,
  }) async {
    try {
      final rows = await Supabase.instance.client
          .from('messages')
          .select('id')
          .eq('phone_number', phoneNumber)
          .eq('delivered', false)
          .like('text', '%$shortUrlId%')
          .order('created_at', ascending: false)
          .limit(1);
      if (rows.isNotEmpty) {
        final id = rows.first['id']?.toString();
        if (id != null && id.isNotEmpty) return id;
      }
    } catch (e) {
      talker.debug('digital receipt: message id lookup failed: $e');
    }
    return null;
  }

  static Future<({String shortUrlId, String? messageId})?> requestReceiptLink({
    required String branchId,
    required String receiptFileName,
    required String phoneNumber,
    String? transactionId,
    int? smsBranchId,
    bool sendSms = true,
  }) async {
    if (branchId.isEmpty || receiptFileName.isEmpty) return null;

    final normalizedPhone = _normalizePhoneForSms(phoneNumber);
    if (normalizedPhone == null) {
      talker.warning('digital receipt: invalid phone "$phoneNumber"');
      return null;
    }
    if (normalizedPhone != phoneNumber.replaceAll(RegExp(r'\D'), '')) {
      talker.debug(
        'digital receipt: normalized phone $phoneNumber → $normalizedPhone',
      );
    }

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
          'phone': normalizedPhone,
          'sendSms': sendSms,
          if (smsBranchId != null) 'smsBranchId': smsBranchId,
          if (transactionId != null && transactionId.isNotEmpty)
            'transactionId': transactionId,
        },
        headers: await SupabaseSessionService.edgeFunctionAuthHeaders(),
      );

      final data = _parseResponseData(response.data);
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

      if (response.status != 200 || data == null) return null;

      if (data['sms_queued'] != true && data['sms_skip_reason'] != null) {
        talker.warning(
          'digital receipt: SMS not queued: ${data['sms_skip_reason']}',
        );
      }

      final url = data['url']?.toString();
      if (url == null || url.isEmpty) return null;

      var messageId = data['message_id']?.toString();
      if ((messageId == null || messageId.isEmpty) &&
          data['sms_queued'] == true) {
        messageId = await _lookupQueuedMessageId(
          phoneNumber: normalizedPhone,
          shortUrlId: url,
        );
        if (messageId != null) {
          talker.info(
            'digital receipt: resolved message_id=$messageId via Supabase query '
            '(redeploy generateReceiptUrl to return message_id in response)',
          );
        } else {
          talker.warning(
            'digital receipt: sms_queued but no message_id — '
            'check messages where text contains short link $url',
          );
        }
      } else if (messageId != null && messageId.isNotEmpty) {
        talker.info(
          'digital receipt: queued message_id=$messageId '
          'short_url=$url transaction=${transactionId ?? "n/a"}',
        );
      }

      return (shortUrlId: url, messageId: messageId);
    } catch (e, s) {
      talker.warning('digital receipt invoke error: $e\n$s');
      return null;
    }
  }
}

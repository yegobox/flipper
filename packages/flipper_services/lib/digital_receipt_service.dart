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
  static const _sendSmsFunctionName = 'sendSms';

  /// In-memory queue — [LocalStorage] only allows fixed keys, so per-transaction
  /// `pending_digital_receipt_*` box writes were silently dropped.
  static final Map<String, bool> _pendingSmsByTransactionId = {};

  static Future<void> queueSmsAfterReceiptUpload(String transactionId) async {
    if (transactionId.isEmpty) return;
    _pendingSmsByTransactionId[transactionId] = true;
    talker.info('digital receipt: queued SMS for transaction $transactionId');
  }

  static bool isQueuedForSms(String transactionId) {
    if (transactionId.isEmpty) return false;
    return _pendingSmsByTransactionId[transactionId] == true;
  }

  static bool _isQueuedForSms(String transactionId) => isQueuedForSms(transactionId);

  static void _clearQueuedForSms(String transactionId) {
    if (transactionId.isEmpty) return;
    _pendingSmsByTransactionId.remove(transactionId);
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

    if (!_isQueuedForSms(transactionId)) {
      talker.debug(
        'digital receipt: skipped — not queued for $transactionId',
      );
      return;
    }

    try {
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
        talker.info('digital receipt: normalized phone $rawPhone → $phone');
      }

      talker.info(
        'digital receipt: resolving SMS branch id for branchId=$branchId',
      );
      final smsBranchId = await _resolveSmsBranchId(branchId);
      if (smsBranchId == null) {
        talker.warning(
          'digital receipt: skipped — branch $branchId has no serverId for SMS credits',
        );
        return;
      }
      talker.info('digital receipt: smsBranchId=$smsBranchId');

      talker.info(
        'digital receipt: invoking generateReceiptUrl for $transactionId '
        'file=$receiptFileName phone=$phone',
      );
      final result = await requestReceiptLink(
        branchId: branchId,
        receiptFileName: receiptFileName,
        phoneNumber: phone,
        transactionId: transactionId,
        smsBranchId: smsBranchId,
      );

      if (result == null) {
        talker.warning(
          'digital receipt: generateReceiptUrl returned no link for $transactionId '
          '(see warnings above for status/body)',
        );
        return;
      }

      final shortUrlId = result.shortUrlId;
      talker.info(
        'digital receipt: short link $shortUrlId queued — '
        'message_id=${result.messageId ?? "n/a"}',
      );

      await _invokeSendSms();

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
    } catch (e, s) {
      talker.error(
        'digital receipt: maybeSendAfterUpload failed for $transactionId: $e',
        e,
        s,
      );
    } finally {
      _clearQueuedForSms(transactionId);
    }
  }

  static Future<int?> _resolveSmsBranchId(String branchId) async {
    try {
      final branch = await ProxyService.getStrategy(
        Strategy.capella,
      ).branch(serverId: branchId);
      final serverId = branch?.serverId;
      if (serverId != null && serverId > 0) return serverId;
    } catch (e, s) {
      talker.warning(
        'digital receipt: branch lookup failed for $branchId: $e',
        e,
        s,
      );
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

  static String _describeFunctionResponse({
    required String functionName,
    required int status,
    required dynamic rawData,
  }) {
    final data = _parseResponseData(rawData);
    final error = data?['error'] ?? data?['message'] ?? data?['msg'];
    final details = data?['details'] ?? data?['hint'];
    final parts = <String>[
      'function=$functionName',
      'status=$status',
      if (error != null) 'error=$error',
      if (details != null) 'details=$details',
      if (data != null && error == null) 'body=$data',
      if (data == null && rawData != null) 'raw=$rawData',
    ];
    return parts.join(' ');
  }

  /// Delivers pending rows in `messages` via the [sendSms] edge function.
  static Future<void> _invokeSendSms() async {
    talker.info('digital receipt: invoking sendSms');
    try {
      final response = await Supabase.instance.client.functions.invoke(
        _sendSmsFunctionName,
        body: <String, dynamic>{},
        headers: await SupabaseSessionService.edgeFunctionAuthHeaders(),
      );
      final data = _parseResponseData(response.data);
      if (response.status == 200) {
        talker.info(
          'digital receipt: sendSms ok status=${response.status} stats=$data',
        );
        return;
      }
      talker.warning(
        'digital receipt: sendSms failed — '
        '${_describeFunctionResponse(functionName: _sendSmsFunctionName, status: response.status, rawData: response.data)}',
      );
    } catch (e, s) {
      talker.error('digital receipt: sendSms invoke error: $e', e, s);
    }
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
      talker.info(
        'digital receipt: normalized phone $phoneNumber → $normalizedPhone',
      );
    }

    talker.info('digital receipt: ensuring Supabase session for edge functions');
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
      final body = <String, dynamic>{
        'branchId': branchId,
        'imageInS3': receiptFileName,
        'phone': normalizedPhone,
        'sendSms': sendSms,
        if (smsBranchId != null) 'smsBranchId': smsBranchId,
        if (transactionId != null && transactionId.isNotEmpty)
          'transactionId': transactionId,
      };
      talker.info(
        'digital receipt: POST $_functionName body=$body',
      );

      final response = await Supabase.instance.client.functions.invoke(
        _functionName,
        body: body,
        headers: await SupabaseSessionService.edgeFunctionAuthHeaders(),
      );

      final data = _parseResponseData(response.data);
      if (response.status == 200 && data != null) {
        talker.info(
          'digital receipt: generateReceiptUrl ok data=$data',
        );
      } else {
        talker.warning(
          'digital receipt: generateReceiptUrl failed — '
          '${_describeFunctionResponse(functionName: _functionName, status: response.status, rawData: response.data)}',
        );
      }

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
      if (url == null || url.isEmpty) {
        talker.warning(
          'digital receipt: generateReceiptUrl 200 but missing url in response: $data',
        );
        return null;
      }

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
      talker.error(
        'digital receipt: generateReceiptUrl invoke error: $e',
        e,
        s,
      );
      return null;
    }
  }
}

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/order_form_whatsapp_client.dart';
import 'package:flipper_services/data_connector_url.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/models/branch_sms_config.model.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

class SmsNotificationService {
  static final Repository _repository = Repository();

  /// Same cost as [sendSms] edge function (`SMS_CREDIT_COST`).
  static const int smsCreditCost = 30;

  static Future<void> sendOrderRequestNotification({
    required String receiverBranchId,
    required String orderDetails,
    required String requesterPhone,
  }) async {
    try {
      final receiverConfig = await getBranchSmsConfig(receiverBranchId);
      if (receiverConfig?.smsPhoneNumber == null) return;

      final text = 'New Order Request: $orderDetails from $requesterPhone';
      await _dispatchOrderNotification(
        config: receiverConfig!,
        text: text,
        branchId: receiverBranchId,
      );
    } catch (e) {
      print('Error sending order request notification: $e');
    }
  }

  static Future<void> sendOrderStatusNotification({
    required String requesterBranchId,
    required String orderDetails,
    required String status,
  }) async {
    try {
      final branchConfig = await getBranchSmsConfig(requesterBranchId);
      if (branchConfig?.smsPhoneNumber == null) return;

      final text = 'Order Status Update: $orderDetails has been $status';
      await _dispatchOrderNotification(
        config: branchConfig!,
        text: text,
        branchId: requesterBranchId,
      );
    } catch (e) {
      print('Error sending order status notification: $e');
    }
  }

  static Future<void> _dispatchOrderNotification({
    required BranchSmsConfig config,
    required String text,
    required String branchId,
  }) async {
    final phone = config.smsPhoneNumber!;
    if (config.enableSms) {
      await createMessage(
        text: text,
        phoneNumber: phone,
        branchId: branchId,
        messageSource: 'sms',
        delivered: false,
      );
    }
    if (config.enableWhatsapp) {
      await sendWhatsAppTextNotification(
        text: text,
        phoneNumber: phone,
        branchId: branchId,
        whatsappProvider: config.whatsappProvider,
      );
    }
  }

  /// Deducts credits, sends WhatsApp text, and audits a delivered WhatsApp row.
  static Future<bool> sendWhatsAppTextNotification({
    required String text,
    required String phoneNumber,
    required String branchId,
    int? whatsappProvider,
  }) async {
    final charged = await deductSmsCredits(branchId: branchId);
    if (!charged) {
      talker.warning(
        'WhatsApp order notification skipped — insufficient credits for $branchId',
      );
      return false;
    }

    try {
      final dataConnectorUrl = await resolveEbmDataConnectorUrl();
      if (dataConnectorUrl == null || dataConnectorUrl.isEmpty) {
        talker.warning(
          'WhatsApp order notification skipped — Ebm.dataConnectorUrl is not set '
          '(taxServerUrl is not used)',
        );
        return false;
      }
      final provider = WhatsAppChannel.toApiProvider(whatsappProvider);
      final client = await createOrderFormWhatsAppClient(
        dataConnectorUrl: dataConnectorUrl,
        defaultProvider: provider,
      );
      final result = await client.sendText(
        phone: phoneNumber,
        text: text,
        provider: provider,
      );
      if (result.needsOptIn) {
        talker.info(
          'WhatsApp order notification queued pending Meta opt-in '
          '(queue_id=${result.queueId})',
        );
        await createMessage(
          text: text,
          phoneNumber: phoneNumber,
          branchId: branchId,
          messageSource: 'whatsapp',
          messageType: 'text',
          delivered: false,
          whatsappMessageId: result.queueId,
        );
        return true;
      }
      await createMessage(
        text: text,
        phoneNumber: phoneNumber,
        branchId: branchId,
        messageSource: 'whatsapp',
        messageType: 'text',
        delivered: true,
        whatsappMessageId: result.messageId,
      );
      return result.ok;
    } catch (e, s) {
      talker.error('WhatsApp order notification failed: $e', e, s);
      await createMessage(
        text: text,
        phoneNumber: phoneNumber,
        branchId: branchId,
        messageSource: 'whatsapp',
        messageType: 'text',
        delivered: false,
      );
      return false;
    }
  }

  /// Deducts [smsCreditCost] via `deduct_credits` for [branchId] (UUID).
  static Future<bool> deductSmsCredits({required String branchId}) async {
    try {
      await Supabase.instance.client.rpc(
        'deduct_credits',
        params: <String, dynamic>{
          'branch_id': branchId,
          'amount': smsCreditCost,
        },
      );
      return true;
    } catch (e, s) {
      talker.warning('deduct_credits failed for $branchId: $e\n$s');
      return false;
    }
  }

  static Future<BranchSmsConfig?> getBranchSmsConfig(
    String branchId, {
    bool forceRemote = false,
  }) async {
    try {
      final configs = await _repository.get<BranchSmsConfig>(
        query: Query(where: [Where('branchId').isExactly(branchId)]),
        policy: forceRemote
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );
      return configs.firstOrNull;
    } catch (e) {
      print('Error fetching branch SMS config: $e');
      return null;
    }
  }

  static Future<void> createMessage({
    required String text,
    required String phoneNumber,
    required String branchId,
    String messageSource = 'sms',
    String? messageType,
    bool delivered = false,
    String? whatsappMessageId,
  }) async {
    final message = Message(
      text: text,
      phoneNumber: phoneNumber,
      delivered: delivered,
      branchId: branchId,
      messageSource: messageSource,
      messageType: messageType,
      whatsappMessageId: whatsappMessageId,
    );
    await _repository.upsert<Message>(message);
  }

  static Future<void> updateBranchSmsConfig({
    required String branchId,
    String? smsPhoneNumber,
    bool? enableSms,
    bool? enableWhatsapp,
    int? whatsappProvider,
    @Deprecated('Use enableSms') bool? enableNotification,
  }) async {
    try {
      final smsFlag = enableSms ?? enableNotification;
      var config = await getBranchSmsConfig(branchId);

      // After local Brick repair, BranchSmsConfig may be empty while Supabase
      // still has the row — reuse that id so we don't INSERT a second branch_id.
      final remoteId = await _remoteBranchSmsConfigId(branchId);
      final id = remoteId ?? config?.id;

      if (config == null) {
        config = BranchSmsConfig(
          id: id,
          branchId: branchId,
          smsPhoneNumber: smsPhoneNumber,
          enableSms: smsFlag ?? false,
          enableWhatsapp: enableWhatsapp ?? false,
          whatsappProvider: whatsappProvider ?? WhatsAppChannel.openwa,
        );
      } else {
        config = BranchSmsConfig(
          id: id ?? config.id,
          branchId: branchId,
          smsPhoneNumber: smsPhoneNumber ?? config.smsPhoneNumber,
          enableSms: smsFlag ?? config.enableSms,
          enableWhatsapp: enableWhatsapp ?? config.enableWhatsapp,
          whatsappProvider: whatsappProvider ?? config.whatsappProvider,
        );
      }

      await _repository.upsert<BranchSmsConfig>(config);

      // Conflict on branch_id (unique), not id — local may mint a new UUID.
      await Supabase.instance.client.from('branch_sms_configs').upsert(
        {
          'id': config.id,
          'branch_id': config.branchId,
          'sms_phone_number': config.smsPhoneNumber,
          'enable_sms': config.enableSms,
          'enable_whatsapp': config.enableWhatsapp,
          'whatsapp_provider': config.whatsappProvider,
        },
        onConflict: 'branch_id',
      );
    } catch (e) {
      print('Error updating branch SMS config: $e');
      rethrow;
    }
  }

  static Future<String?> _remoteBranchSmsConfigId(String branchId) async {
    try {
      final row = await Supabase.instance.client
          .from('branch_sms_configs')
          .select('id')
          .eq('branch_id', branchId)
          .maybeSingle();
      final id = row?['id']?.toString();
      return (id != null && id.isNotEmpty) ? id : null;
    } catch (e) {
      talker.debug('_remoteBranchSmsConfigId failed for $branchId: $e');
      return null;
    }
  }

  /// Resolves Capella branch [serverId] used as the SMS credits gate.
  static Future<int?> resolveSmsBranchServerId(String branchId) async {
    try {
      final branch = await ProxyService.getStrategy(
        Strategy.capella,
      ).branch(serverId: branchId);
      final serverId = branch?.serverId;
      if (serverId != null && serverId > 0) return serverId;
    } catch (e, s) {
      talker.warning('resolveSmsBranchServerId failed for $branchId: $e\n$s');
    }
    final parsed = int.tryParse(branchId);
    return parsed != null && parsed > 0 ? parsed : null;
  }
}

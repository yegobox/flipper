import 'package:supabase_models/brick/models/branch_sms_config.model.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

class SmsNotificationService {
  static final Repository _repository = Repository();

  static Future<void> sendOrderRequestNotification({
    required int receiverBranchId,
    required String orderDetails,
    required String requesterPhone,
  }) async {
    try {
      // Send notification to receiver branch
      final receiverConfig = await getBranchSmsConfig(receiverBranchId);
      if (receiverConfig?.smsPhoneNumber != null &&
          receiverConfig!.enableOrderNotification) {
        await createMessage(
          text: 'New Order Request: $orderDetails from $requesterPhone',
          phoneNumber: receiverConfig.smsPhoneNumber!,
          branchId: receiverBranchId,
        );
      }
    } catch (e) {
      // Log error but don't throw to prevent disrupting main flow
      print('Error sending order request notification: $e');
    }
  }

  static Future<void> sendOrderStatusNotification({
    required int requesterBranchId,
    required String orderDetails,
    required String status,
  }) async {
    try {
      final branchConfig = await getBranchSmsConfig(requesterBranchId);
      if (branchConfig?.smsPhoneNumber != null &&
          branchConfig!.enableOrderNotification) {
        await createMessage(
          text: 'Order Status Update: $orderDetails has been $status',
          phoneNumber: branchConfig.smsPhoneNumber!,
          branchId: requesterBranchId,
        );
      }
    } catch (e) {
      // Log error but don't throw to prevent disrupting main flow
      print('Error sending order status notification: $e');
    }
  }

  static Future<BranchSmsConfig?> getBranchSmsConfig(int branchId) async {
    try {
      final configs = await _repository.get<BranchSmsConfig>(
        query: Query(
          where: [Where('branchId').isExactly(branchId)],
        ),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
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
    required int branchId,
  }) async {
    final message = Message(
      text: text,
      phoneNumber: phoneNumber,
      delivered: false,
      branchId: branchId,
    );
    await _repository.upsert<Message>(message);
  }

  static Future<void> updateBranchSmsConfig({
    required int branchId,
    String? smsPhoneNumber,
    bool? enableNotification,
  }) async {
    try {
      var config = await getBranchSmsConfig(branchId);

      if (config == null) {
        config = BranchSmsConfig(
          branchId: branchId,
          smsPhoneNumber: smsPhoneNumber,
          enableOrderNotification: enableNotification ?? false,
        );
      } else {
        config = BranchSmsConfig(
          id: config.id,
          branchId: branchId,
          smsPhoneNumber: smsPhoneNumber ?? config.smsPhoneNumber,
          enableOrderNotification:
              enableNotification ?? config.enableOrderNotification,
        );
      }

      await _repository.upsert<BranchSmsConfig>(config);
    } catch (e) {
      print('Error updating branch SMS config: $e');
      rethrow;
    }
  }
}

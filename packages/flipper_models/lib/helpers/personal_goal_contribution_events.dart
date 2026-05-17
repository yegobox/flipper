import 'package:flipper_models/helpers/personal_goal_contribution_device_key.dart';
import 'package:flipper_services/personal_goal_push_service.dart';
import 'package:flipper_web/services/ditto_service.dart';

/// Ditto `events` channel for cross-device personal-goal credit toasts.
String personalGoalsEventChannel(String branchId) => 'personal_goals_$branchId';

/// Event [type] stored in Ditto `events` (replicated to other devices).
class PersonalGoalContributionEvent {
  PersonalGoalContributionEvent._();

  static const String type = 'personal_goal_contribution';

  static const String keyType = 'type';
  static const String keyGoalId = 'goalId';
  static const String keyGoalName = 'goalName';
  static const String keyAmount = 'amount';
  static const String keyBranchId = 'branchId';
  static const String keyTransactionId = 'transactionId';
  static const String keySourceDeviceKey = 'sourceDeviceKey';

  /// Publishes a mesh event so other devices can show a notification when Ditto
  /// syncs (foreground, background, or recent apps — not when fully force-stopped).
  static Future<void> publish({
    required String branchId,
    required String goalId,
    required String goalName,
    required double amount,
    required String? transactionId,
  }) async {
    if (branchId.isEmpty || amount <= 0) return;

    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return;

    final sourceDeviceKey = await personalGoalContributionDeviceKey();
    final channel = personalGoalsEventChannel(branchId);

    await DittoService.instance.saveEvent(
      {
        keyType: type,
        keyGoalId: goalId,
        keyGoalName: goalName,
        keyAmount: amount,
        keyBranchId: branchId,
        if (transactionId != null && transactionId.isNotEmpty)
          keyTransactionId: transactionId,
        keySourceDeviceKey: sourceDeviceKey,
      },
      channel,
    );

    // Server FCM for devices that are backgrounded or force-stopped.
    await PersonalGoalPushService.notifyContribution(
      branchId: branchId,
      goalName: goalName,
      amount: amount,
      sourceDeviceKey: sourceDeviceKey,
      transactionId: transactionId,
    );
  }

  static bool isContributionEvent(Map<String, dynamic> doc) =>
      doc[keyType]?.toString() == type;

  static String? sourceDeviceKey(Map<String, dynamic> doc) =>
      doc[keySourceDeviceKey]?.toString();

  static String goalName(Map<String, dynamic> doc) =>
      doc[keyGoalName]?.toString() ?? 'Goal';

  static double amount(Map<String, dynamic> doc) {
    final v = doc[keyAmount];
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0;
  }

  static String eventDedupeKey(Map<String, dynamic> doc) {
    final id = doc['_id']?.toString() ?? doc['id']?.toString();
    if (id != null && id.isNotEmpty) return id;
    return '${doc[keyTransactionId]}_${doc[keyGoalId]}_${doc[keyAmount]}';
  }
}

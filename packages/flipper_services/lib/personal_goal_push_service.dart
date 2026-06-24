import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/personal_goal_fcm_background.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Invokes Supabase Edge Function [notify-personal-goal-contribution] so FCM
/// reaches other devices when the app is backgrounded or force-stopped.
class PersonalGoalPushService {
  PersonalGoalPushService._();

  static const _functionName = 'notify-personal-goal-contribution';

  static Future<void> notifyContribution({
    required String branchId,
    required String goalName,
    required double amount,
    required String sourceDeviceKey,
    String? transactionId,
    String? businessId,
    String? currencySymbol,
  }) async {
    if (branchId.isEmpty || amount <= 0) return;

    final resolvedBusinessId =
        businessId ?? ProxyService.box.getBusinessId()?.toString();
    if (resolvedBusinessId == null || resolvedBusinessId.isEmpty) {
      talker.debug('personal goal push: skip — no businessId');
      return;
    }

    String? currency = currencySymbol;
    if (currency == null || currency.isEmpty) {
      try {
        final business = await ProxyService.strategy.getBusiness(
          businessId: resolvedBusinessId,
        );
        currency = business?.currency?.toString();
      } catch (_) {}
    }

    try {
      await Supabase.instance.client.functions.invoke(
        _functionName,
        body: {
          'businessId': resolvedBusinessId,
          'branchId': branchId,
          'goalName': goalName,
          'amount': amount,
          'sourceDeviceKey': sourceDeviceKey,
          if (transactionId != null && transactionId.isNotEmpty)
            'transactionId': transactionId,
          'currencySymbol': currency ?? 'RWF',
        },
      );
    } catch (e, s) {
      talker.debug('personal goal push invoke failed: $e\n$s');
    }
  }

  /// Body text matching server notification for local display.
  static String localNotificationBody({
    required String goalName,
    required double amount,
    String currencySymbol = 'RWF',
  }) {
    final rounded = (amount * 100).round() / 100;
    final amountText = rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(2);
    return '$goalName: +$currencySymbol $amountText saved';
  }

  static bool isPersonalGoalFcm(Map<String, dynamic> data) =>
      data['type']?.toString() == kPersonalGoalContributionFcmType;
}

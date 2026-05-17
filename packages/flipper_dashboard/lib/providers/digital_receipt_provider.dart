import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Whether the active branch has SMS notifications enabled in admin settings.
final branchSmsNotificationsEnabledProvider = FutureProvider<bool>((ref) async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) return false;
  final config = await SmsNotificationService.getBranchSmsConfig(branchId);
  return config?.enableOrderNotification ?? false;
});

/// Quick-selling checkout: when true, receipt is sent digitally (SMS) instead of opening a PDF.
final digitalReceiptToggleProvider = StateProvider<bool>((ref) => false);

/// Resets the digital receipt toggle for the next sale (default: off).
void resetDigitalReceiptToggle(WidgetRef ref) {
  ref.read(digitalReceiptToggleProvider.notifier).state = false;
}

import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';

class AdminSettingsService {
  static Future<void> toggleDownload() async {
    await ProxyService.box.writeBool(
      key: 'doneDownloadingAsset',
      value: !ProxyService.box.doneDownloadingAsset(),
    );
    ProxyService.strategy.reDownloadAsset();
  }

  static Future<void> toggleForceUPSERT() async {
    try {
      await ProxyService.strategy.variants(
        taxTyCds: ProxyService.box.vatEnabled()
            ? ['A', 'B', 'C']
            : ['D'],
        branchId: ProxyService.box.getBranchId()!,
        fetchRemote: true,
      );
      await ProxyService.box.writeBool(
        key: 'forceUPSERT',
        value: !ProxyService.box.forceUPSERT(),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> toggleTaxService() async {
    await ProxyService.box.writeBool(
      key: 'stopTaxService',
      value: !ProxyService.box.stopTaxService()!,
    );
  }

  static Future<void> togglePos(bool value) async {
    if (value) {
      await ProxyService.box.writeBool(key: 'isOrdersDefault', value: false);
    }
    await ProxyService.box.writeBool(key: 'isPosDefault', value: value);
  }

  static Future<void> toggleOrders(bool value) async {
    if (value) {
      await ProxyService.box.writeBool(key: 'isPosDefault', value: false);
    }
    await ProxyService.box.writeBool(key: 'isOrdersDefault', value: value);
  }

  static Future<void> toggleDebug() async {
    await ProxyService.box.writeBool(
      key: 'enableDebug',
      value: !ProxyService.box.enableDebug()!,
    );
  }

  static Future<Map<String, dynamic>?> loadSmsConfig() async {
    try {
      final config = await SmsNotificationService.getBranchSmsConfig(
        ProxyService.box.getBranchId()!,
      );
      if (config != null) {
        return {
          'smsPhoneNumber': config.smsPhoneNumber,
          'enableOrderNotification': config.enableOrderNotification,
        };
      }
      return null;
    } catch (e) {
      print('Error loading SMS config: $e');
      return null;
    }
  }

  static Future<void> updateSmsConfig({
    required String phone,
    required bool enable,
  }) async {
    await SmsNotificationService.updateBranchSmsConfig(
      branchId: ProxyService.box.getBranchId()!,
      smsPhoneNumber: phone,
      enableNotification: enable,
    );
  }

  static bool isValidPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleanPhone.startsWith('+')) {
      return RegExp(r'^\+\d{10,15}$').hasMatch(cleanPhone);
    }
    return RegExp(r'^\d{10,15}$').hasMatch(cleanPhone);
  }

  static String formatPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!cleanPhone.startsWith('+')) {
      return '+$cleanPhone';
    }
    return cleanPhone;
  }
}

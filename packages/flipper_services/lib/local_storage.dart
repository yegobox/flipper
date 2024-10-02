import 'package:flipper_services/proxy.dart';

import 'abstractions/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceStorage implements LocalStorage {
  late SharedPreferencesWithCache prefs;

  Future<LocalStorage> initializePreferences() async {
    prefs = await SharedPreferencesWithCache.create(
        // You can add cache options here if needed
        cacheOptions: const SharedPreferencesWithCacheOptions(
      // When an allowlist is included, any keys that aren't included cannot be used.
      allowList: <String>{
        'branchId',
        'businessId',
        'userId',
        'userPhone',
        'needLinkPhoneNumber',
        'getServerUrl',
        'currentOrderId',
        'isProformaMode',
        'isTrainingMode',
        'isAutoPrintEnabled',
        'isAutoBackupEnabled',
        'hasSignedInForAutoBackup',
        'gdID',
        'isAnonymous',
        'bearerToken',
        'getIsTokenRegistered',
        'defaultApp',
        'whatsAppToken',
        'createdAt',
        'id',
        'encryptionKey',
        'authComplete',
        'uid',
        'bhfId',
        'tin',
        'currentSaleCustomerPhoneNumber',
        'getRefundReason',
        'mrc',
        'isPosDefault',
        'isOrdersDefault',
        'version',
        'UToken',
        'itemPerPage',
        'isOrdering',
        'couponCode',
        'discountRate',
        'paymentType',
        'yegoboxLoggedInUserPermission',
        'doneDownloadingAsset',
        'doneMigrateToLocal',
        'forceUPSERT',
        'dbVersion',
        'performBackup'
      },
    ));
    return this;
  }

  @override
  int? readInt({required String key}) {
    return prefs.getInt(key);
  }

  @override
  Future<void> writeInt({required dynamic key, required int value}) async {
    prefs.setInt(key, value);
  }

  @override
  void remove({required String key}) {
    prefs.remove(key);
  }

  @override
  int? getBranchId() {
    return prefs.getInt('branchId');
  }

  @override
  int? getBusinessId() {
    return prefs.getInt('businessId');
  }

  @override
  int? getUserId() {
    final userId = prefs.get('userId');
    if (userId is String) {
      final parsedUserId = int.tryParse(userId);
      return parsedUserId ?? null;
    } else if (userId is int) {
      return userId;
    }
    return null;
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  @override
  String? getUserPhone() {
    return prefs.getString('userPhone');
  }

  @override
  bool getNeedAccountLinkWithPhone() {
    return prefs.getBool('needLinkPhoneNumber') ?? false;
  }

  @override
  String? getServerUrl() {
    final ebm = ProxyService.local.ebm(branchId: getBranchId()!);
    if (ebm != null) {
      return ebm.taxServerUrl;
    }
    return prefs.getString('getServerUrl');
  }

  @override
  int? currentOrderId() {
    return prefs.getInt('currentOrderId');
  }

  @override
  bool isProformaMode() {
    return prefs.getBool('isProformaMode') ?? false;
  }

  @override
  bool isTrainingMode() {
    return prefs.getBool('isTrainingMode') ?? false;
  }

  @override
  bool isAutoPrintEnabled() {
    return prefs.getBool('isAutoPrintEnabled') ?? false;
  }

  @override
  bool isAutoBackupEnabled() {
    return prefs.getBool('isAutoBackupEnabled') ?? false;
  }

  @override
  bool hasSignedInForAutoBackup() {
    return prefs.getBool('hasSignedInForAutoBackup') ?? false;
  }

  @override
  String? gdID() {
    return prefs.getString('gdID');
  }

  @override
  bool isAnonymous() {
    return prefs.getBool('isAnonymous') ?? false;
  }

  @override
  String? getBearerToken() {
    return prefs.getString('bearerToken');
  }

  @override
  bool? getIsTokenRegistered() {
    return prefs.getBool('getIsTokenRegistered') ?? false;
  }

  @override
  String getDefaultApp() {
    return prefs.getString('defaultApp') ?? "1";
  }

  @override
  String? whatsAppToken() {
    return prefs.getString('whatsAppToken');
  }

  @override
  String? paginationCreatedAt() {
    return prefs.getString('createdAt') ?? '';
  }

  @override
  int? paginationId() {
    return prefs.getInt('id') ?? 0;
  }

  @override
  String? readString({required String key}) {
    return prefs.getString(key);
  }

  @override
  Future<void> writeString({required String key, required String value}) async {
    await prefs.setString(key, value);
  }

  @override
  Future<void> writeBool({required String key, required bool value}) async {
    await prefs.setBool(key, value);
  }

  @override
  bool? readBool({required String key}) {
    return prefs.getBool(key);
  }

  @override
  Future<void> clear() async {
    return await prefs.clear();
  }

  @override
  String encryptionKey() {
    return prefs.getString('encryptionKey') ?? "";
  }

  @override
  Future<bool> authComplete() async {
    return await prefs.getBool("authComplete") ?? false;
  }

  @override
  String uid() {
    return prefs.getString('uid') ?? "";
  }

  @override
  String? bhfId() {
    final ebm = ProxyService.local.ebm(branchId: getBranchId()!);
    if (ebm != null) {
      return ebm.bhfId;
    }
    return prefs.getString('bhfId');
  }

  @override
  int tin() {
    return prefs.getInt('tin') ?? -1;
  }

  @override
  String? currentSaleCustomerPhoneNumber() {
    return prefs.getString('currentSaleCustomerPhoneNumber');
  }

  @override
  String? getRefundReason() {
    return prefs.getString("getRefundReason");
  }

  @override
  String? mrc() {
    final mc = prefs.getString("mrc");
    return (mc == null || mc.isEmpty) ? null : mc;
  }

  @override
  bool? isPosDefault() {
    return prefs.getBool("isPosDefault") ?? true;
  }

  @override
  bool? isOrdersDefault() {
    return prefs.getBool("isOrdersDefault") ?? true;
  }

  @override
  int? itemPerPage() {
    return prefs.getInt('itemPerPage') ?? 250;
  }

  @override
  bool? isOrdering() {
    return prefs.getBool('isOrdering') ?? false;
  }

  @override
  String? couponCode() {
    return prefs.getString('couponCode');
  }

  @override
  double? discountRate() {
    return prefs.getDouble('discountRate');
  }

  @override
  String? paymentType() {
    return prefs.getString('paymentType');
  }

  @override
  String? yegoboxLoggedInUserPermission() {
    return prefs.getString('yegoboxLoggedInUserPermission');
  }

  @override
  bool doneDownloadingAsset() {
    return prefs.getBool('doneDownloadingAsset') ?? false;
  }

  @override
  bool doneMigrateToLocal() {
    return prefs.getBool('doneMigrateToLocal') ?? false;
  }

  @override
  bool forceUPSERT() {
    return prefs.getBool('forceUPSERT') ?? false;
  }

  @override
  int? dbVersion() {
    return prefs.getInt('dbVersion') ?? 6;
  }
  
}

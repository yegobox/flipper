import 'abstractions/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceStorage implements LocalStorage {
  late SharedPreferences prefs;
  Future<LocalStorage> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  @override
  int? readInt({required String key}) {
    return prefs.getInt(key);
  }

  @override
  Future<bool> writeInt({required dynamic key, required int value}) async {
    return prefs.setInt(key, value);
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
    return prefs.getString('serverUrl');
  }

  @override
  int? currentOrderId() {
    return prefs.getInt('currentOrderId');
  }

  @override
  bool isPoroformaMode() {
    return prefs.getBool('isPoroformaMode') ?? false;
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
  Future<bool> writeString({required String key, required String value}) async {
    return await prefs.setString(key, value);
  }

  @override
  Future<bool> writeBool({required String key, required bool value}) async {
    return await prefs.setBool(key, value);
  }

  @override
  bool? readBool({required String key}) {
    return prefs.getBool(key);
  }

  @override
  Future<bool> clear() async {
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
  String bhfId() {
    return prefs.getString('bhfId') ?? "";
  }

  @override
  int tin() {
    return prefs.getInt('tin') ?? -1;
  }

  @override
  String? currentSaleCustomerPhoneNumber() {
    return prefs.getString('currentSaleCustomerPhoneNumber');
  }
}

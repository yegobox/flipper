import 'abstractions/storage.dart';
import 'package:get_storage/get_storage.dart';
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
    return prefs.getString('encryptionKey')!;
  }

  @override
  Future<bool> authComplete()async {
    return await prefs.getBool("authComplete")??false;
  }
}

class BoxStorage implements LocalStorage {
  final box = GetStorage();
  @override
  int readInt({required String key}) {
    return box.read(key);
  }

  @override
  Future<bool> writeInt({required dynamic key, required dynamic value}) async {
    await box.write(key, value);
    return true;
  }

  @override
  remove({required String key}) {
    box.remove(key);
  }

  @override
  int? getBranchId() {
    return box.read('branchId');
  }

  @override
  int? getBusinessId() {
    return box.read('businessId');
  }

  int? getUserId() {
    // get the userId as a dynamic value
    dynamic userId = box.read('userId');
    // check if the userId is a String
    if (userId is String) {
      // check if the userId is a valid int
      if (isNumeric(userId)) {
        // parse the userId as an int
        return int.parse(userId);
      } else {
        // return null or some default value
        return null;
      }
    } else if (userId is int) {
      // return the userId as an int
      return userId;
    } else {
      // return null or some default value
      return null;
    }
  }

// a helper function to check if a String is a valid int
  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  @override
  String? getUserPhone() {
    return box.read('userPhone');
  }

  @override
  bool getNeedAccountLinkWithPhone() {
    return box.read('needLinkPhoneNumber') ?? false;
  }

  @override
  String? getServerUrl() {
    return box.read('serverUrl');
  }

  @override
  int? currentOrderId() {
    return box.read('currentOrderId');
  }

  @override
  bool isPoroformaMode() {
    return box.read('isPoroformaMode') ?? false;
  }

  @override
  bool isTrainingMode() {
    return box.read('isTrainingMode') ?? false;
  }

  @override
  bool isAutoPrintEnabled() {
    return box.read('isAutoPrintEnabled') ?? false;
  }

  @override
  bool isAutoBackupEnabled() {
    return box.read('isAutoBackupEnabled') ?? false;
  }

  @override
  bool hasSignedInForAutoBackup() {
    return box.read('hasSignedInForAutoBackup') ?? false;
  }

  @override
  String? gdID() {
    return box.read('gdID');
  }

  @override
  bool isAnonymous() {
    return box.read('isAnonymous') ?? false;
  }

  @override
  String? getBearerToken() {
    return box.read('bearerToken');
  }

  @override
  bool? getIsTokenRegistered() {
    return box.read('getIsTokenRegistered') ?? false;
  }

  @override
  String getDefaultApp() {
    return box.read('defaultApp') ?? "1";
  }

  @override
  String? whatsAppToken() {
    return box.read('whatsAppToken');
  }

  @override
  String? paginationCreatedAt() {
    return box.read('createdAt') ?? '';
  }

  @override
  int? paginationId() {
    return box.read('id') ?? 0;
  }

  @override
  String readString({required String key}) {
    return box.read('key');
  }

  @override
  Future<bool> writeString({required String key, required String value}) async {
    await box.write(key, value);
    return true;
  }

  @override
  Future<bool> writeBool({required String key, required bool value}) async {
    await box.write(key, value);
    return true;
  }

  @override
  bool? readBool({required String key}) {
    return box.read(key);
  }

  @override
  Future<bool> clear() async {
    return true;
  }

  @override
  String encryptionKey() {
    return box.read('encryptionKey');
  }

  @override
  Future<bool> authComplete() {
    // TODO: implement authComplete
    throw UnimplementedError();
  }
}

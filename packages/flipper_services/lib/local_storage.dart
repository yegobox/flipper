import 'abstractions/storage.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageImpl implements LocalStorage {
  final box = GetStorage();
  @override
  dynamic read({required String key}) {
    return box.read(key);
  }

  @override
  Future<bool> write({required dynamic key, required dynamic value}) async {
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
    return box.read('getIsTokenRegistered');
  }

  @override
  int getDefaultApp() {
    return box.read('defaultApp') ?? 1;
  }
}

import 'abstractions/storage.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageImpl implements LocalStorage {
  final box = GetStorage();
  @override
  dynamic read({required String key}) {
    return box.read(key);
  }

  @override
  bool write({required dynamic key, required dynamic value}) {
    box.write(key, value);
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

  @override
  String? getUserId() {
    return box.read('userId');
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
}

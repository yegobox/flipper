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
    return box.read('businessId');
  }

  @override
  int? getBusinessId() {
    return box.read('branchId');
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
    return box.read('needLinkPhoneNumber')??false;
  }
}

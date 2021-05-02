import 'abstractions/storage.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageImpl implements LocalStorage {
  final box = GetStorage();
  @override
  dynamic read({required String key}) {
    return box.read(key);
  }

  @override
  bool write({required String key, required String value}) {
    box.write(key, value);
    return true;
  }

  @override
  remove({required String key}) {
    box.remove(key);
  }
}

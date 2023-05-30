import 'package:get_storage/get_storage.dart';

abstract class Storage {
  dynamic read({required String key});
  dynamic remove({required String key});
  Future<bool> write({required String key, required dynamic value});
}

class StorageImpl implements Storage {
  final box = GetStorage();
  @override
  read({required String key}) {
    return box.read(key);
  }

  @override
  remove({required String key}) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<bool> write({required String key, required value}) async {
    await box.write(key, value);
    return true;
  }
}

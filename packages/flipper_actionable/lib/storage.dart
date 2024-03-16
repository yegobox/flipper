abstract class Storage {
  dynamic read({required String key});
  dynamic remove({required String key});
  Future<bool> write({required String key, required dynamic value});
}

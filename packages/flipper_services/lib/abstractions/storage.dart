abstract class LocalStorage {
  dynamic read({required String key});
  dynamic remove({required String key});
  bool write({required String key, required dynamic value});
  int? getBusinessId();
  int? getBranchId();
  String? getUserPhone();
  String? getUserId();
  bool getNeedAccountLinkWithPhone();
}

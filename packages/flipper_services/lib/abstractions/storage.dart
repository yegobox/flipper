abstract class LocalStorage {
  dynamic read({required String key});
  dynamic remove({required String key});
  Future<bool> write({required String key, required dynamic value});
  int? getBusinessId();
  int? getBranchId();
  bool? getIsTokenRegistered();
  String? getUserPhone();
  String? getUserId();
  bool getNeedAccountLinkWithPhone();
  String? getServerUrl();
  int? currentOrderId();
  bool isPoroformaMode();
  bool isTrainingMode();
  bool isAnonymous();
  bool isAutoPrintEnabled();
  bool isAutoBackupEnabled();
  bool hasSignedInForAutoBackup();
  String? gdID();
  String? getBearerToken();
}

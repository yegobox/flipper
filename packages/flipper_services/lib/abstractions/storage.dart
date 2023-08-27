abstract class LocalStorage {
  int? readInt({required String key});
  String? readString({required String key});
  bool? readBool({required String key});
  dynamic remove({required String key});
  Future<bool> writeInt({required String key, required int value});
  Future<bool> writeString({required String key, required String value});
  Future<bool> writeBool({required String key, required bool value});
  int? getBusinessId();
  int? getBranchId();
  bool? getIsTokenRegistered();
  String? getUserPhone();
  int? getUserId();
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
  String getDefaultApp();
  String? whatsAppToken();
  String? paginationCreatedAt();
  int? paginationId();
}

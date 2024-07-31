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
  String encryptionKey();
  Future<bool> clear();
  Future<bool> authComplete();

  /// firebase token, we take uid from logged in device (mobile)
  /// then we send it back to server and get equivalent token uid
  /// we send this while performing ProxyService.isar.login()
  String uid();
  String? bhfId();
  int tin();

  /// the intention of this is to store a temporal phone number for the sale
  /// this is useful when we did not save full customer will all details but we need a phone number
  /// to show on receipt.
  String? currentSaleCustomerPhoneNumber();
  String? getRefundReason();
  String? mrc();
  bool? isPosDefault();
  bool? isOrdersDefault();
}

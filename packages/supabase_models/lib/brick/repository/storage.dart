abstract class LocalStorage {
  int? readInt({required String key});
  String? readString({required String key});
  bool? readBool({required String key});
  dynamic remove({required String key});
  Future<void> writeInt({required String key, required int value});
  Future<void> writeDouble({required String key, required double value});
  Future<void> writeString({required String key, required String value});
  Future<void> writeBool({required String key, required bool value});
  int? getBusinessId();
  int? getBusinessServerId();
  String? getReceiptFileName();
  int? getBranchId();
  String? branchIdString();
  int? getBranchServerId();
  bool? getIsTokenRegistered();
  String? getUserPhone();
  int? getUserId();
  double? getCashReceived();
  bool getNeedAccountLinkWithPhone();
  Future<String?> getServerUrl();
  int? currentOrderId();
  bool isProformaMode();
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
  Future<void> clear();
  Future<bool> authComplete();
  String transactionId();
  String pmtTyCd();

  /// Returns the payment method code for a given payment method name
  /// Cash: 01
  /// Credit Card: 02
  /// CASH/CREDIT: 03
  /// BANK CHECK: 04
  /// DEBIT&CREDIT CARD: 05
  /// MOBILE MONEY: 06
  /// OTHER: 07
  String paymentMethodCode(String paymentMethod);

  /// firebase token, we take uid from logged in device (mobile)
  /// then we send it back to server and get equivalent token uid
  /// we send this while performing
  String uid();
  Future<String?> bhfId();
  int tin();

  /// the intention of this is to store a temporal phone number for the sale
  /// this is useful when we did not save full customer will all details but we need a phone number
  /// to show on receipt.
  String? currentSaleCustomerPhoneNumber();
  String? getRefundReason();
  String? mrc();
  bool? isPosDefault();
  bool? isOrdersDefault();
  int? itemPerPage();
  bool? isOrdering();
  String? couponCode();
  double? discountRate();
  String? paymentType();

  String? yegoboxLoggedInUserPermission();
  bool doneDownloadingAsset();
  bool doneMigrateToLocal();
  bool forceUPSERT();
  int? dbVersion();
  bool? pinLogin();
  String? customerName();
  bool? stopTaxService();
  bool? enableDebug();
  bool? switchToCloudSync();
  bool? useInHouseSyncGateway();
  String? customPhoneNumberForPayment();
  String? purchaseCode();

  bool A4();
  int? numberOfPayments();
  bool exportAsPdf();
  bool transactionInProgress();
  String stockInOutType();
  String defaultCurrency();
  bool lockPatching();

  /// Returns the main database filename
  /// Default is 'flipper_v17.sqlite'
  String getDatabaseFilename();

  /// Sets the main database filename
  Future<void> setDatabaseFilename(String filename);

  /// Returns the queue database filename
  /// Default is 'brick_offline_queue_v17.sqlite'
  String getQueueFilename();

  /// Sets the queue database filename
  Future<void> setQueueFilename(String filename);
  Future<void> setForceLogout(bool value);
  bool getForceLogout();
  String? customerTin();
  bool vatEnabled();
}

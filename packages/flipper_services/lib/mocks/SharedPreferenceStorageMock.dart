import 'package:flipper_services/abstractions/storage.dart';

class SharedPreferenceStorageMock implements LocalStorage {
  @override
  Future<bool> clear() async {
    // Simulate clearing preferences and return true to indicate success
    return true;
  }

  @override
  bool? enableDebug() {
    return false;
  }

  @override
  bool pinLogin() {
    return false;
  }

  @override
  int? dbVersion() {
    return 3;
  }

  @override
  bool doneMigrateToLocal() {
    return true;
  }

  @override
  String encryptionKey() {
    return "1,2,3,4"; // Sample encryption key
  }

  @override
  bool forceUPSERT() {
    return false;
  }

  @override
  int? currentOrderId() {
    return 12345; // Sample current order ID
  }

  @override
  String? gdID() {
    return "gd-12345"; // Sample GD ID
  }

  @override
  String? getBearerToken() {
    return "sample_bearer_token"; // Sample bearer token
  }

  @override
  int? getBranchId() {
    return 1; // Sample branch ID
  }

  @override
  int? getBusinessId() {
    return 100; // Sample business ID
  }

  @override
  String getDefaultApp() {
    return "1"; // Sample default app version
  }

  @override
  bool? getIsTokenRegistered() {
    return true; // Sample token registration status
  }

  @override
  bool getNeedAccountLinkWithPhone() {
    return true; // Sample requirement status
  }

  @override
  Future<String?> getServerUrl() async {
    return "https://example.com"; // Sample server URL
  }

  @override
  int? getUserId() {
    return 24300; // Sample user ID
  }

  @override
  String? getUserPhone() {
    return "+1234567890"; // Sample user phone number
  }

  @override
  bool hasSignedInForAutoBackup() {
    return true; // Sample auto-backup sign-in status
  }

  @override
  bool isAnonymous() {
    return false; // Sample anonymity status
  }

  @override
  bool isAutoBackupEnabled() {
    return true; // Sample auto-backup enable status
  }

  @override
  bool isAutoPrintEnabled() {
    return false; // Sample auto-print enable status
  }

  @override
  bool isProformaMode() {
    return false; // Sample poroforma mode status
  }

  @override
  bool isTrainingMode() {
    return true; // Sample training mode status
  }

  @override
  String? paginationCreatedAt() {
    return "2024-08-10T12:00:00Z"; // Sample pagination creation date
  }

  @override
  int? paginationId() {
    return 67890; // Sample pagination ID
  }

  @override
  bool? readBool({required String key}) {
    return key == "sampleBoolKey" ? true : false; // Sample boolean read
  }

  @override
  int? readInt({required String key}) {
    return key == "sampleIntKey" ? 42 : null; // Sample integer read
  }

  @override
  String? readString({required String key}) {
    return key == "sampleStringKey"
        ? "sampleValue"
        : null; // Sample string read
  }

  @override
  Future<bool> remove({required String key}) async {
    return true; // Simulate successful removal
  }

  @override
  String? whatsAppToken() {
    return "whatsapp_token"; // Sample WhatsApp token
  }

  @override
  Future<bool> writeBool({required String key, required bool value}) async {
    return true; // Simulate successful boolean write
  }

  @override
  Future<bool> writeInt({required String key, required int value}) async {
    return true; // Simulate successful integer write
  }

  @override
  Future<bool> writeString({required String key, required String value}) async {
    return true; // Simulate successful string write
  }

  Future<LocalStorage> initializePreferences() async {
    return this;
  }

  @override
  Future<bool> authComplete() async {
    return true; // Sample authentication completion status
  }

  @override
  String uid() {
    return "sample_uid"; // Sample UID
  }

  @override
  Future<String> bhfId() async {
    return "sample_bhf_id"; // Sample BHF ID
  }

  @override
  int tin() {
    return 1234567890; // Sample TIN
  }

  @override
  String? currentSaleCustomerPhoneNumber() {
    return "+0987654321"; // Sample current sale customer phone number
  }

  @override
  String? getRefundReason() {
    return "sample_refund_reason"; // Sample refund reason
  }

  @override
  String? mrc() {
    return "sample_mrc"; // Sample MRC
  }

  @override
  bool? isPosDefault() {
    return true; // Sample POS default status
  }

  @override
  bool? isOrdersDefault() {
    return false; // Sample orders default status
  }

  @override
  int? itemPerPage() {
    return 20; // Sample items per page
  }

  @override
  bool? isOrdering() {
    return null;
  }

  @override
  String? couponCode() {
    return "01";
  }

  @override
  double? discountRate() {
    return 1.0;
  }

  @override
  String? paymentType() {
    return "Cash";
  }

  @override
  String? yegoboxLoggedInUserPermission() {
    return "admin";
  }

  @override
  bool doneDownloadingAsset() {
    return false;
  }

  @override
  String? customerName() {
    // TODO: implement customerName
    return "N/A";
  }

  @override
  bool? stopTaxService() {
    // TODO: implement stopTaxService
    return false;
  }

  @override
  bool? switchToCloudSync() {
    // TODO: implement switchToCloudSync
    return true;
  }

  @override
  bool? useInHouseSyncGateway() {
    return true;
  }

  @override
  String customPhoneNumberForPayment() {
    return "";
  }

  @override
  String? purchaseCode() {
    return "";
  }

  @override
  bool A4() {
    // TODO: implement A4
    return false;
  }

  @override
  int? numberOfPayments() {
    return 1;
  }

  @override
  bool exportAsPdf() {
    return false;
  }
  
  @override
  String transactionId() {
    // TODO: implement transactionId
    throw UnimplementedError();
  }
}

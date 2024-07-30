import 'package:flipper_services/abstractions/storage.dart';

class SharedPreferenceStorageMock implements LocalStorage {
  @override
  Future<bool> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  String encryptionKey() {
    throw UnimplementedError();
  }

  @override
  int? currentOrderId() {
    // TODO: implement currentOrderId
    throw UnimplementedError();
  }

  @override
  String? gdID() {
    // TODO: implement gdID
    throw UnimplementedError();
  }

  @override
  String? getBearerToken() {
    // TODO: implement getBearerToken
    throw UnimplementedError();
  }

  @override
  int? getBranchId() {
    return null;
  }

  @override
  int? getBusinessId() {
    return null;
  }

  @override
  String getDefaultApp() {
    return "1";
  }

  @override
  bool? getIsTokenRegistered() {
    // TODO: implement getIsTokenRegistered
    throw UnimplementedError();
  }

  @override
  bool getNeedAccountLinkWithPhone() {
    // TODO: implement getNeedAccountLinkWithPhone
    throw UnimplementedError();
  }

  @override
  String? getServerUrl() {
    // TODO: implement getServerUrl
    throw UnimplementedError();
  }

  @override
  int? getUserId() {
    return 24300;
  }

  @override
  String? getUserPhone() {
    // TODO: implement getUserPhone
    throw UnimplementedError();
  }

  @override
  bool hasSignedInForAutoBackup() {
    // TODO: implement hasSignedInForAutoBackup
    throw UnimplementedError();
  }

  @override
  bool isAnonymous() {
    // TODO: implement isAnonymous
    throw UnimplementedError();
  }

  @override
  bool isAutoBackupEnabled() {
    // TODO: implement isAutoBackupEnabled
    throw UnimplementedError();
  }

  @override
  bool isAutoPrintEnabled() {
    // TODO: implement isAutoPrintEnabled
    throw UnimplementedError();
  }

  @override
  bool isPoroformaMode() {
    // TODO: implement isPoroformaMode
    throw UnimplementedError();
  }

  @override
  bool isTrainingMode() {
    // TODO: implement isTrainingMode
    throw UnimplementedError();
  }

  @override
  String? paginationCreatedAt() {
    // TODO: implement paginationCreatedAt
    throw UnimplementedError();
  }

  @override
  int? paginationId() {
    // TODO: implement paginationId
    throw UnimplementedError();
  }

  @override
  bool? readBool({required String key}) {
    // TODO: implement readBool
    throw UnimplementedError();
  }

  @override
  int? readInt({required String key}) {
    // TODO: implement readInt
    throw UnimplementedError();
  }

  @override
  String? readString({required String key}) {
    // TODO: implement readString
    throw UnimplementedError();
  }

  @override
  remove({required String key}) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  String? whatsAppToken() {
    // TODO: implement whatsAppToken
    throw UnimplementedError();
  }

  @override
  Future<bool> writeBool({required String key, required bool value}) {
    // TODO: implement writeBool
    throw UnimplementedError();
  }

  @override
  Future<bool> writeInt({required String key, required int value}) {
    // TODO: implement writeInt
    throw UnimplementedError();
  }

  @override
  Future<bool> writeString({required String key, required String value}) {
    // TODO: implement writeString
    throw UnimplementedError();
  }

  Future<LocalStorage> initializePreferences() async {
    return this;
  }

  @override
  Future<bool> authComplete() {
    // TODO: implement authComplete
    throw UnimplementedError();
  }

  @override
  String uid() {
    // TODO: implement uid
    throw UnimplementedError();
  }

  @override
  String bhfId() {
    // TODO: implement bhfId
    throw UnimplementedError();
  }

  @override
  int tin() {
    // TODO: implement tin
    throw UnimplementedError();
  }

  @override
  String? stockUpdataBle() {
    // TODO: implement stockUpdataBle
    throw UnimplementedError();
  }

  @override
  String? variantUpdataBle() {
    // TODO: implement variantUpdataBle
    throw UnimplementedError();
  }

  @override
  String? currentSaleCustomerPhoneNumber() {
    // TODO: implement currentSaleCustomerPhoneNumber
    throw UnimplementedError();
  }

  @override
  String? getRefundReason() {
    // TODO: implement getRefundReason
    throw UnimplementedError();
  }

  @override
  String? mrc() {
    // TODO: implement mrc
    throw UnimplementedError();
  }
}

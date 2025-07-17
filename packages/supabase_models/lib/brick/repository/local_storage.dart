import 'dart:convert';
import 'dart:io';
// import 'package:flipper_services/proxy.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:supabase_models/brick/repository/storage.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Current version of the preferences file format
/// Increment this when making breaking changes to the preferences structure
const String _kPreferencesVersion = '33';
const String _kPreferencesKey = 'flipper_preferences';
const String _kPreferencesBackupKey = 'flipper_preferences_backup';

/// A robust implementation of LocalStorage that uses JSON files in the document directory
/// This implementation is designed to be resilient to power outages and corruption
class SharedPreferenceStorage implements LocalStorage {
  // The in-memory cache of preferences
  Map<String, dynamic> _cache = {};

  // The file path where preferences are stored
  late String _filePath;
  late String _backupFilePath;

  // Set of allowed keys (same as the original implementation)
  static const Set<String> _allowedKeys = {
    // System keys
    '_preferencesVersion',

    'branchId',
    'pmtTyCd',
    'businessId',
    'userId',
    'userPhone',
    'getCashReceived',
    'getReceiptFileName',
    'needLinkPhoneNumber',
    'getServerUrl',
    'currentOrderId',
    'isProformaMode',
    'isTrainingMode',
    'isAutoPrintEnabled',
    'isAutoBackupEnabled',
    'transactionId',
    'hasSignedInForAutoBackup',
    'gdID',
    'isAnonymous',
    'bearerToken',
    'getIsTokenRegistered',
    'defaultApp',
    'whatsAppToken',
    'createdAt',
    'id',
    'encryptionKey',
    'authComplete',
    'uid',
    'bhfId',
    'tin',
    'currentSaleCustomerPhoneNumber',
    'getRefundReason',
    'mrc',
    'isPosDefault',
    'isOrdersDefault',
    'version',
    'UToken',
    'itemPerPage',
    'isOrdering',
    'couponCode',
    'discountRate',
    'paymentType',
    'yegoboxLoggedInUserPermission',
    'doneDownloadingAsset',
    'doneMigrateToLocal',
    'forceUPSERT',
    'dbVersion',
    'performBackup',
    'pinLogin',
    'customerName',
    'stopTaxService',
    'enableDebug',
    'switchToCloudSync',
    'useInHouseSyncGateway',
    'customPhoneNumberForPayment',
    'purchaseCode',
    'A4',
    'numberOfPayments',
    'exportAsPdf',
    'getBusinessServerId',
    'getBranchServerId',
    'referralCode',
    'transactionInProgress',
    'stockInOutType',
    'defaultCurrency',
    'userName',
    'lockPatching',
    'last_internet_connection_timestamp',
    'databaseFilename',
    'queueFilename',
    'forceLogout',
    'branchIdString',
    'customerTin',
    'vatEnabled',
    // Add new preference keys above this line
  };

  SharedPreferences? _webPrefs;

  /// Initialize the preferences by loading from the JSON file
  Future<LocalStorage> initializePreferences() async {
    if (kIsWeb) {
      // On web, use shared_preferences
      try {
        _webPrefs = await SharedPreferences.getInstance();
        final jsonString = _webPrefs!.getString(_kPreferencesKey);
        if (jsonString != null) {
          _cache = jsonDecode(jsonString);

          // Initialize version if not present
          _cache['_preferencesVersion'] ??= _kPreferencesVersion;
        } else {
          _cache = {
            '_preferencesVersion': _kPreferencesVersion,
          };
          await _webPrefs!.setString(_kPreferencesKey, jsonEncode(_cache));
        }
      } catch (e) {
        _cache = {};
      }
      return this;
    }

    // Check if we're in a test environment
    bool isTestEnv = const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;

    try {
      // Get the document directory (same as used by repository.dart)
      final directory = await _getStorageDirectory();

      // Ensure the directory exists
      if (!await Directory(directory).exists()) {
        await Directory(directory).create(recursive: true);
      }

      // Set the file paths with version number
      _filePath = path.join(
          directory, '${_kPreferencesKey}_v${_kPreferencesVersion}.json');
      _backupFilePath = path.join(
          directory, '${_kPreferencesBackupKey}_v${_kPreferencesVersion}.json');

      // Load preferences from file
      await _loadPreferences();

      // Ensure the file exists by saving the current cache (even if empty)
      // This is critical for fresh installs
      await _savePreferences();
    } catch (e) {
      // If there's an error, start with an empty cache
      _cache = {};

      // In test environments, set default paths to avoid LateInitializationError
      if (isTestEnv) {
        try {
          final tempDir = Directory.systemTemp;
          _filePath = path.join(tempDir.path,
              '${_kPreferencesKey}_v${_kPreferencesVersion}_test.json');
          _backupFilePath = path.join(tempDir.path,
              '${_kPreferencesBackupKey}_v${_kPreferencesVersion}_test.json');
        } catch (pathError) {
          // Fallback to hardcoded paths if even temp directory fails
          _filePath = '${_kPreferencesKey}_v${_kPreferencesVersion}_test.json';
          _backupFilePath =
              '${_kPreferencesBackupKey}_v${_kPreferencesVersion}_test.json';
        }
      }

      // Try to create the file anyway
      try {
        await _savePreferences();
      } catch (saveError) {
        // Ignore errors during recovery attempt
      }
    }

    return this;
  }

  /// Get the storage directory path
  Future<String> _getStorageDirectory() async {
    if (Platform.isWindows) {
      final appDir = await getApplicationDocumentsDirectory();
      return path.join(appDir.path, '.db');
    } else if (Platform.isAndroid) {
      return await getDatabasesPath();
    } else if (Platform.isIOS || Platform.isMacOS) {
      final documents = await getApplicationDocumentsDirectory();
      return documents.path;
    } else {
      // For other platforms, use application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      return path.join(appDir.path, '.db');
    }
  }

  /// Load preferences from the JSON file
  Future<void> _loadPreferences() async {
    try {
      final file = File(_filePath);

      // If the file doesn't exist, try to restore from backup
      if (!file.existsSync()) {
        final backupFile = File(_backupFilePath);
        if (backupFile.existsSync()) {
          await backupFile.copy(_filePath);
        }
      }

      // If the file exists after potential restore, read it
      if (file.existsSync()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(jsonString);
        _cache = data;
      }
    } catch (e) {
      // If there's an error reading the file, try the backup
      try {
        final backupFile = File(_backupFilePath);
        if (backupFile.existsSync()) {
          final jsonString = await backupFile.readAsString();
          final Map<String, dynamic> data = jsonDecode(jsonString);
          _cache = data;

          // Restore the main file from backup
          await backupFile.copy(_filePath);
        }
      } catch (backupError) {
        // If backup also fails, start with an empty cache
        _cache = {};
      }
    }
  }

  /// Save preferences to the JSON file using a safe write pattern
  Future<void> _savePreferences() async {
    try {
      final file = File(_filePath);
      final tempFile = File('$_filePath.tmp');

      // Write to a temporary file first
      await tempFile.writeAsString(jsonEncode(_cache), flush: true);

      // Rename the temporary file to the actual file (atomic operation)
      await tempFile.rename(_filePath);

      // Create a backup after successful write
      await file.copy(_backupFilePath);
    } catch (e) {
      // If the rename fails, try a direct write approach as fallback
      try {
        final file = File(_filePath);
        await file.writeAsString(jsonEncode(_cache), flush: true);
      } catch (directWriteError) {
        // Log the error but continue execution
        print('Error writing preferences file: $directWriteError');
      }
    }
  }

  /// Check if a key is allowed
  bool _isKeyAllowed(String key) {
    return _allowedKeys.contains(key);
  }

  @override
  int? readInt({required String key}) {
    if (!_isKeyAllowed(key)) return null;
    return _cache[key] as int?;
  }

  @override
  Future<void> writeInt({required dynamic key, required int value}) async {
    if (!_isKeyAllowed(key.toString())) return;
    _cache[key.toString()] = value;
    if (kIsWeb) {
      if (_webPrefs != null) {
        await _webPrefs!.setString(_kPreferencesKey, jsonEncode(_cache));
      }
    } else {
      await _savePreferences();
    }
  }

  @override
  Future<void> remove({required String key}) async {
    if (!_isKeyAllowed(key)) return;
    _cache.remove(key);
    if (kIsWeb) {
      if (_webPrefs != null) {
        await _webPrefs!.setString(_kPreferencesKey, jsonEncode(_cache));
      }
    } else {
      await _savePreferences();
    }
  }

  @override
  int? getBranchId() {
    return _cache['branchId'] as int?;
  }

  @override
  int? getBusinessId() {
    return _cache['businessId'] as int?;
  }

  @override
  int? getUserId() {
    final userId = _cache['userId'];
    if (userId is String) {
      final parsedUserId = int.tryParse(userId);
      return parsedUserId;
    } else if (userId is int) {
      return userId;
    }
    return null;
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  @override
  String? getUserPhone() {
    return _cache['userPhone'] as String?;
  }

  @override
  bool getNeedAccountLinkWithPhone() {
    return (_cache['needLinkPhoneNumber'] as bool?) ?? false;
  }

  @override
  Future<String?> getServerUrl() async {
    return _cache['getServerUrl'] as String?;
  }

  @override
  int? currentOrderId() {
    return _cache['currentOrderId'] as int?;
  }

  @override
  bool isProformaMode() {
    return (_cache['isProformaMode'] as bool?) ?? false;
  }

  @override
  bool isTrainingMode() {
    return (_cache['isTrainingMode'] as bool?) ?? false;
  }

  @override
  bool isAutoPrintEnabled() {
    return (_cache['isAutoPrintEnabled'] as bool?) ?? false;
  }

  @override
  bool isAutoBackupEnabled() {
    return (_cache['isAutoBackupEnabled'] as bool?) ?? false;
  }

  @override
  bool hasSignedInForAutoBackup() {
    return (_cache['hasSignedInForAutoBackup'] as bool?) ?? false;
  }

  @override
  String? gdID() {
    return _cache['gdID'] as String?;
  }

  @override
  bool isAnonymous() {
    return (_cache['isAnonymous'] as bool?) ?? false;
  }

  @override
  String? getBearerToken() {
    return _cache['bearerToken'] as String?;
  }

  @override
  bool? getIsTokenRegistered() {
    return (_cache['getIsTokenRegistered'] as bool?) ?? false;
  }

  @override
  String? getDefaultApp() {
    return _cache['defaultApp'] as String?;
  }

  @override
  String? whatsAppToken() {
    return _cache['whatsAppToken'] as String?;
  }

  @override
  String? paginationCreatedAt() {
    return _cache['createdAt'] as String?;
  }

  @override
  int? paginationId() {
    return _cache['id'] as int? ?? 0;
  }

  @override
  String? readString({required String key}) {
    if (!_isKeyAllowed(key)) return null;
    return _cache[key] as String?;
  }

  @override
  Future<void> writeString({required String key, required String value}) async {
    if (!_isKeyAllowed(key)) return;
    _cache[key] = value;
    if (kIsWeb) {
      if (_webPrefs != null) {
        await _webPrefs!.setString(_kPreferencesKey, jsonEncode(_cache));
      }
    } else {
      await _savePreferences();
    }
  }

  @override
  bool? readBool({required String key}) {
    if (!_isKeyAllowed(key)) return null;
    return _cache[key] as bool?;
  }

  @override
  Future<void> writeBool({required String key, required bool value}) async {
    if (!_isKeyAllowed(key)) return;
    _cache[key] = value;
    if (kIsWeb) {
      if (_webPrefs != null) {
        await _webPrefs!.setString(_kPreferencesKey, jsonEncode(_cache));
      }
    } else {
      await _savePreferences();
    }
  }

  @override
  Future<void> clear() async {
    _cache.clear();
    if (kIsWeb) {
      if (_webPrefs != null) {
        await _webPrefs!.setString(_kPreferencesKey, jsonEncode(_cache));
      }
    } else {
      await _savePreferences();
    }
  }

  @override
  String encryptionKey() {
    return _cache['encryptionKey'] as String? ?? "";
  }

  @override
  Future<bool> authComplete() async {
    return (_cache['authComplete'] as bool?) ?? false;
  }

  @override
  String uid() {
    return (_cache['uid'] as String?) ?? "";
  }

  @override
  Future<String?> bhfId() async {
    return _cache['bhfId'] as String?;
  }

  @override
  int tin() {
    return (_cache['tin'] as int?) ?? 999909695;
  }

  @override
  String? currentSaleCustomerPhoneNumber() {
    return _cache['currentSaleCustomerPhoneNumber'] as String?;
  }

  @override
  String? getRefundReason() {
    return _cache['getRefundReason'] as String?;
  }

  @override
  String? mrc() {
    return _cache['mrc'] as String?;
  }

  @override
  bool? isPosDefault() {
    return (_cache['isPosDefault'] as bool?) ?? true;
  }

  @override
  bool? isOrdersDefault() {
    return (_cache['isOrdersDefault'] as bool?) ?? false;
  }

  @override
  int? itemPerPage() {
    return (_cache['itemPerPage'] as int?) ?? 1000;
  }

  @override
  bool? isOrdering() {
    return (_cache['isOrdering'] as bool?) ?? false;
  }

  @override
  String? couponCode() {
    return _cache['couponCode'] as String?;
  }

  @override
  double? discountRate() {
    final value = _cache['discountRate'];
    if (value is String) {
      return double.tryParse(value);
    } else if (value is double) {
      return value;
    }
    return null;
  }

  @override
  String? paymentType() {
    return _cache['paymentType'] as String?;
  }

  @override
  String? yegoboxLoggedInUserPermission() {
    return _cache['yegoboxLoggedInUserPermission'] as String?;
  }

  @override
  bool doneDownloadingAsset() {
    return (_cache['doneDownloadingAsset'] as bool?) ?? false;
  }

  @override
  bool doneMigrateToLocal() {
    return (_cache['doneMigrateToLocal'] as bool?) ?? false;
  }

  @override
  bool forceUPSERT() {
    return (_cache['forceUPSERT'] as bool?) ?? false;
  }

  @override
  int? dbVersion() {
    return _cache['dbVersion'] as int?;
  }

  @override
  bool? pinLogin() {
    return (_cache['pinLogin'] as bool?) ?? false;
  }

  @override
  String? customerName() {
    return _cache['customerName'] as String?;
  }

  @override
  bool? stopTaxService() {
    return (_cache['stopTaxService'] as bool?) ?? false;
  }

  @override
  bool? enableDebug() {
    return (_cache['enableDebug'] as bool?) ?? false;
  }

  @override
  bool? switchToCloudSync() {
    return (_cache['switchToCloudSync'] as bool?) ?? false;
  }

  @override
  bool? useInHouseSyncGateway() {
    return (_cache['useInHouseSyncGateway'] as bool?) ?? false;
  }

  @override
  String? customPhoneNumberForPayment() {
    return _cache['customPhoneNumberForPayment'] as String?;
  }

  @override
  String? purchaseCode() {
    return _cache['purchaseCode'] as String?;
  }

  @override
  bool A4() {
    return (_cache['A4'] as bool?) ?? false;
  }

  @override
  int? numberOfPayments() {
    return _cache['numberOfPayments'] as int?;
  }

  @override
  bool exportAsPdf() {
    return (_cache['exportAsPdf'] as bool?) ?? false;
  }

  @override
  String transactionId() {
    return (_cache['transactionId'] as String?) ?? "";
  }

  @override
  int? getBranchServerId() {
    return _cache['getBranchServerId'] as int?;
  }

  @override
  int? getBusinessServerId() {
    return _cache['getBusinessServerId'] as int?;
  }

  /// allow us to lock some part of cron operation while there is transaction hapening.
  @override
  bool transactionInProgress() {
    return (_cache['transactionInProgress'] as bool?) ?? false;
  }

  @override
  String stockInOutType() {
    return (_cache['stockInOutType'] as String?) ?? "";
  }

  @override
  String defaultCurrency() {
    return (_cache['defaultCurrency'] as String?) ?? "RWF";
  }

  @override
  bool lockPatching() {
    return (_cache['lockPatching'] as bool?) ?? false;
  }

  @override
  String getDatabaseFilename() {
    return (_cache['databaseFilename'] as String?) ?? 'flipper_v$_kPreferencesVersion.sqlite';
  }

  @override
  Future<void> setDatabaseFilename(String filename) async {
    _cache['databaseFilename'] = filename;
    if (kIsWeb) {
      if (_webPrefs != null) {
        await _webPrefs!.setString(_kPreferencesKey, jsonEncode(_cache));
      }
    } else {
      await _savePreferences();
    }
  }

  @override
  String getQueueFilename() {
    return (_cache['queueFilename'] as String?) ??
        'brick_offline_queue_v17.sqlite';
  }

  @override
  Future<void> setQueueFilename(String filename) async {
    _cache['queueFilename'] = filename;
    if (kIsWeb) {
      if (_webPrefs != null) {
        await _webPrefs!.setString(_kPreferencesKey, jsonEncode(_cache));
      }
    } else {
      await _savePreferences();
    }
  }

  @override
  bool getForceLogout() {
    try {
      // Check if the key exists in the cache
      if (_cache.containsKey('forceLogout')) {
        // Try to get the value as a bool
        final value = _cache['forceLogout'];
        if (value is bool) {
          return value;
        } else {
          // If the value is not a bool, log the issue and reset it
          print('Warning: forceLogout value is not a bool: $value');
          _cache['forceLogout'] = false;
          _savePreferences(); // Save the corrected value
          return false;
        }
      }
      // If the key doesn't exist, return false
      return false;
    } catch (e) {
      // If any error occurs, log it and return false
      print('Error getting forceLogout value: $e');
      return false;
    }
  }

  @override
  Future<void> setForceLogout(bool value) async {
    try {
      print('Setting forceLogout to: $value');
      _cache['forceLogout'] = value;

      // Save the preferences immediately
      if (kIsWeb) {
        if (_webPrefs != null) {
          await _webPrefs!.setString('flipper_preferences', jsonEncode(_cache));
          print('Saved forceLogout to web preferences: $value');
        } else {
          print('Warning: _webPrefs is null, could not save forceLogout');
        }
      } else {
        await _savePreferences();
        print('Saved forceLogout to preferences: $value');
      }
    } catch (e) {
      print('Error setting forceLogout value: $e');
    }
  }

  @override
  String? branchIdString() {
    return _cache['branchIdString'] as String?;
  }

  @override
  String paymentMethodCode(String paymentMethod) {
    // Map payment method names to their corresponding codes
    switch (paymentMethod.toUpperCase()) {
      case 'CASH':
        return '01';
      case 'CREDIT':
      case 'CREDIT CARD':
        return '02';
      case 'CASH/CREDIT':
        return '03';
      case 'BANK CHECK':
        return '04';
      case 'DEBIT&CREDIT CARD':
        return '05';
      case 'MOBILE MONEY':
        return '06';
      case 'OTHER':
      default:
        return '07';
    }
  }

  @override
  String pmtTyCd() {
    return _cache['pmtTyCd'] as String? ?? "01";
  }

  @override
  double? getCashReceived() {
    return _cache['getCashReceived'] as double? ?? 0.0;
  }

  @override
  Future<void> writeDouble({required String key, required double value}) async {
    if (!_isKeyAllowed(key.toString())) return;
    _cache[key.toString()] = value;
    if (kIsWeb) {
      if (_webPrefs != null) {
        await _webPrefs!.setString(_kPreferencesKey, jsonEncode(_cache));
      }
    } else {
      await _savePreferences();
    }
  }

  @override
  String? getReceiptFileName() {
    return _cache['getReceiptFileName'] as String?;
  }

  @override
  String? customerTin() {
    return _cache['customerTin'] as String?;
  }

  @override
  bool vatEnabled() {
    return _cache['vatEnabled'] as bool? ?? true;
  }
}

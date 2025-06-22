import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import '../services/admin_settings_service.dart';

class AdminController extends ChangeNotifier {
  bool _isPosDefault = false;
  bool _isOrdersDefault = true;
  bool _enableDebug = false;
  bool _filesDownloaded = false;
  bool _forceUPSERT = false;
  bool _stopTaxService = false;
  bool _switchToCloudSync = false;
  String? _smsPhoneNumber;
  bool _enableSmsNotification = false;
  String? _phoneError;

  // Getters
  bool get isPosDefault => _isPosDefault;
  bool get isOrdersDefault => _isOrdersDefault;
  bool get enableDebug => _enableDebug;
  bool get filesDownloaded => _filesDownloaded;
  bool get forceUPSERT => _forceUPSERT;
  bool get stopTaxService => _stopTaxService;
  bool get switchToCloudSync => _switchToCloudSync;
  String? get smsPhoneNumber => _smsPhoneNumber;
  bool get enableSmsNotification => _enableSmsNotification;
  String? get phoneError => _phoneError;

  AdminController() {
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    _isPosDefault = ProxyService.box.readBool(key: 'isPosDefault') ?? false;
    _enableDebug = ProxyService.box.readBool(key: 'enableDebug') ?? false;
    _isOrdersDefault =
        ProxyService.box.readBool(key: 'isOrdersDefault') ?? true;
    _filesDownloaded =
        ProxyService.box.readBool(key: 'doneDownloadingAsset') ?? true;
    _forceUPSERT = ProxyService.box.forceUPSERT();
    _stopTaxService = ProxyService.box.stopTaxService() ?? false;
    _switchToCloudSync = ProxyService.box.switchToCloudSync() ?? false;
    await _loadSmsConfig();
    notifyListeners();
  }

  Future<void> _loadSmsConfig() async {
    final config = await AdminSettingsService.loadSmsConfig();
    if (config != null) {
      _smsPhoneNumber = config['smsPhoneNumber'];
      _enableSmsNotification = config['enableOrderNotification'];
      notifyListeners();
    }
  }

  Future<void> toggleDownload() async {
    await AdminSettingsService.toggleDownload();
    _filesDownloaded = ProxyService.box.doneDownloadingAsset();
    notifyListeners();
  }

  Future<void> toggleForceUPSERT() async {
    await AdminSettingsService.toggleForceUPSERT();
    _forceUPSERT = ProxyService.box.forceUPSERT();
    notifyListeners();
  }

  Future<void> toggleTaxService() async {
    await AdminSettingsService.toggleTaxService();
    _stopTaxService = ProxyService.box.stopTaxService()!;
    notifyListeners();
  }

  Future<void> togglePos(bool value) async {
    await AdminSettingsService.togglePos(value);
    _isPosDefault = value;
    if (value) {
      _isOrdersDefault = false;
    }
    notifyListeners();
  }

  Future<void> toggleOrders(bool value) async {
    await AdminSettingsService.toggleOrders(value);
    _isOrdersDefault = value;
    if (value) {
      _isPosDefault = false;
    }
    notifyListeners();
  }

  Future<void> toggleDebug() async {
    await AdminSettingsService.toggleDebug();
    _enableDebug = ProxyService.box.enableDebug()!;
    notifyListeners();
  }

  Future<void> updateSmsConfig({String? phone, bool? enable}) async {
    if (phone != null && phone.isNotEmpty) {
      if (!AdminSettingsService.isValidPhoneNumber(phone)) {
        _phoneError =
            'Please enter a valid phone number with country code (e.g., +250783054874)';
        notifyListeners();
        return;
      }
      phone = AdminSettingsService.formatPhoneNumber(phone);
    }

    try {
      await AdminSettingsService.updateSmsConfig(
        phone: phone ?? _smsPhoneNumber ?? '',
        enable: enable ?? _enableSmsNotification,
      );

      if (phone != null) _smsPhoneNumber = phone;
      if (enable != null) _enableSmsNotification = enable;
      _phoneError = null;
      notifyListeners();
    } catch (e) {
      _phoneError = 'Failed to update SMS configuration';
      notifyListeners();
    }
  }
}

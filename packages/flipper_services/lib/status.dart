import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

abstract class Status {
  Future<void> appBarColor(Color color);
  void updateStatusColor();
  ReactiveValue<Color?> get statusColor;
  ReactiveValue<String?> get statusText;
  Future<bool> isInternetAvailable();
}

class StatusAppBarForWindowsAndWeb
    with ListenableServiceMixin
    implements Status {
  static const _taxServerDownMsg = "Tax Server is down";
  static const _internetDownMsg = "Flipper could not connect to the internet";

  ReactiveValue<Color?> _statusColor = ReactiveValue<Color?>(Colors.black);
  ReactiveValue<String?> _statusText = ReactiveValue<String?>(null);
  bool _connectivityListening = false;
  bool _taxServerCheckStarted = false;

  @override
  ReactiveValue<Color?> get statusColor => _statusColor;
  @override
  ReactiveValue<String?> get statusText => _statusText;

  @override
  Future<void> appBarColor(color) async {
    _statusColor.value = color;
    notifyListeners();
  }

  @override
  void updateStatusColor() {
    _statusText.value = "";
    // Check initial connectivity and tax server status
    _checkConnectivity();
    // Start listening for periodic tax server checks
    _startTaxServerCheck();
  }

  // Add this method to check initial connectivity
  Future<void> _checkConnectivity() async {
    if (_connectivityListening) return;
    _connectivityListening = true;
    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult
          .any((result) => result != ConnectivityResult.none)) {
        // If connected to the internet, clear only the internet-related error message
        if (_statusText.value == _internetDownMsg) {
          _statusText.value = "";
          _statusColor.value = Colors.black;
          notifyListeners();
        }
      } else {
        // If there's no internet connection
        _statusColor.value = Colors.red;
        _statusText.value = _internetDownMsg;
        notifyListeners();
      }
    });
  }

  // Start periodic check for the tax server
  void _startTaxServerCheck() {
    if (_taxServerCheckStarted) return;
    _taxServerCheckStarted = true;
    // Run once immediately, then every 5s
    _checkTaxServerStatus();
    Stream.periodic(const Duration(seconds: 5)).listen((_) async {
      await _checkTaxServerStatus();
    });
  }

  void _clearTaxServerDownBanner() {
    if (_statusText.value == _taxServerDownMsg) {
      _statusText.value = "";
      _statusColor.value = Colors.black;
      notifyListeners();
    }
  }

  /// Tax health banner is only for VAT/EBM-enabled branches with a tax URL.
  Future<void> _checkTaxServerStatus() async {
    // Don't overwrite a clearer offline message with tax-server noise.
    if (_statusText.value == _internetDownMsg) return;

    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      _clearTaxServerDownBanner();
      return;
    }

    if (ProxyService.box.stopTaxService() ?? false) {
      _clearTaxServerDownBanner();
      return;
    }

    // Resolve VAT from local EBM (source of truth). Do not fall back to
    // turbo.yegobox.com — that falsely flags non-VAT devices as "down".
    bool vatEnabled = ProxyService.box.vatEnabled();
    String? taxServerUrl = await ProxyService.box.getServerUrl();
    try {
      final ebm = await ProxyService.strategy.ebm(
        branchId: branchId,
        fetchRemote: false,
      );
      vatEnabled = ebm?.vatEnabled == true;
      await ProxyService.box.writeBool(key: 'vatEnabled', value: vatEnabled);
      final ebmUrl = ebm?.taxServerUrl;
      if (ebmUrl != null && ebmUrl.isNotEmpty) {
        taxServerUrl = ebmUrl;
      }
    } catch (_) {
      // Keep box/cache values if local EBM read fails.
    }

    if (!vatEnabled) {
      _clearTaxServerDownBanner();
      return;
    }

    if (taxServerUrl == null || taxServerUrl.isEmpty) {
      _clearTaxServerDownBanner();
      return;
    }

    try {
      final response = await http.get(Uri.parse(taxServerUrl));

      if (response.statusCode != 200) {
        _statusText.value = _taxServerDownMsg;
        _statusColor.value = Colors.red;
        notifyListeners();
      } else {
        _clearTaxServerDownBanner();
      }
    } catch (e) {
      // Error checking the tax server (e.g., tax host unreachable)
      _statusText.value = _taxServerDownMsg;
      _statusColor.value = Colors.red;
      notifyListeners();
    }
  }

  @override
  Future<bool> isInternetAvailable() async {
    return await InternetConnectionChecker().hasConnection;
  }

  StatusAppBarForWindowsAndWeb() {
    listenToReactiveValues([_statusColor, _statusText]);
  }
}

class StatusAppBarForAndroidAndIos
    with ListenableServiceMixin
    implements Status {
  ReactiveValue<Color?> _statusColor = ReactiveValue<Color?>(null);
  ReactiveValue<String?> _statusText = ReactiveValue<String?>(null);

  @override
  ReactiveValue<Color?> get statusColor => _statusColor;
  @override
  ReactiveValue<String?> get statusText => _statusText;

  @override
  Future<void> appBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color, // Android physical status bar
        statusBarIconBrightness:
            color.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
      ),
    );

    _statusColor.value = color;
  }

  @override
  void updateStatusColor() {
    _statusText.value = "";

    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult
          .any((result) => result != ConnectivityResult.none)) {
        if (_statusText.value == "flipper could not connect to internet") {
          _statusText.value = "";
          _statusColor.value = Colors.black;
          appBarColor(Colors.black);
        }
      } else {
        _statusColor.value = Color(0xFF8B0000);
        _statusText.value = "flipper could not connect to internet";
        appBarColor(Color(0xFF8B0000));
      }
      notifyListeners();
    });
  }

  StatusAppBarForAndroidAndIos() {
    listenToReactiveValues([_statusColor, _statusText]);
  }
  @override
  Future<bool> isInternetAvailable() async {
    return await InternetConnectionChecker().hasConnection;
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

///TODO: use https://pub.dev/packages/internet_connection_checker_plus to check if we have internet
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
  ReactiveValue<Color?> _statusColor = ReactiveValue<Color?>(Colors.black);
  ReactiveValue<String?> _statusText = ReactiveValue<String?>(null);

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
    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult
          .any((result) => result != ConnectivityResult.none)) {
        // If connected to the internet, clear only the internet-related error message
        if (_statusText.value == "Flipper could not connect to the internet") {
          _statusText.value = "";
          _statusColor.value = Colors.black;
          notifyListeners();
        }
      } else {
        // If there's no internet connection
        _statusColor.value = Colors.red;
        _statusText.value = "Flipper could not connect to the internet";
        notifyListeners();
      }
    });
  }

  // Start periodic check for the tax server
  void _startTaxServerCheck() {
    Stream.periodic(const Duration(seconds: 5)).listen((_) async {
      await _checkTaxServerStatus();
    });
  }

  // Check the status of the tax server
  Future<void> _checkTaxServerStatus() async {
    try {
      final url =
          await ProxyService.box.getServerUrl() ?? "https://example.com";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        _statusText.value = "Tax Server is down";
        _statusColor.value = Colors.red;
        notifyListeners();
      }
    } catch (e) {
      // Error checking the tax server (e.g., no internet)
      _statusText.value = "Tax Server is down";
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
    await FlutterStatusbarcolor.setStatusBarColor(color);
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

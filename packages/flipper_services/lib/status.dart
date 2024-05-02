import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stacked/stacked.dart';

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
  }

  @override
  void updateStatusColor() {
    _statusText.value = "";
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        _statusText.value = "";
        _statusColor.value = Colors.black;
        appBarColor(Colors.black);
      } else {
        _statusColor.value = Colors.red;
        _statusText.value = "Connectivity issues";
        appBarColor(Color(0xFF8B0000));
      }
      notifyListeners();
    });
  }

  StatusAppBarForWindowsAndWeb() {
    listenToReactiveValues([_statusColor, _statusText]);
  }

  @override
  Future<bool> isInternetAvailable() async {
    return await InternetConnectionChecker().hasConnection;
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
      if (connectivityResult != ConnectivityResult.none) {
        _statusText.value = "";
        _statusColor.value = Colors.black;
        appBarColor(Colors.black);
      } else {
        _statusColor.value = Color(0xFF8B0000);
        _statusText.value = "Connectivity issues";
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

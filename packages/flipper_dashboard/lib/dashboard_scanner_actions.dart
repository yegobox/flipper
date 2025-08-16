import 'dart:async';

import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flipper_models/db_model_export.dart'; // For Product
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class DashboardScannerActions implements ScannerActions {
  final BuildContext context;

  DashboardScannerActions(this.context);

  @override
  void onBarcodeDetected(barcode) {
    ProxyService.productService.setBarcode(barcode.rawValue);
  }

  @override
  Future<void> handleLoginScan(String? result) async {
    // This logic is currently in ScannView.scanToLogin.
    // It needs to be moved or abstracted further.
    // For now, let's keep it in ScannView and pass necessary services.
    // The ScannView will call _publishLoginDetails which uses the services.
    // So, this method will not be directly used by ScannView for login intent.
    // It's here to satisfy the interface.
  }

  @override
  Future<void> handleSellingScan(String? code) async {
    Product? product =
        await ProxyService.productService.getProductByBarCode(code: code);
    if (product != null) {
      navigateToSellRoute(product);
      return;
    }
    showSimpleNotification("Product not found");
    pop();
  }

  @override
  void pop() {
    Navigator.of(context).pop();
  }

  @override
  void navigateToSellRoute(product) {
    Navigator.of(context).pushNamed('/sell', arguments: product);
  }

  @override
  void showSimpleNotification(String message) {
    showToast(context, message);
  }

  @override
  int getUserId() => ProxyService.box.getUserId()!;
  @override
  int getBusinessId() => ProxyService.box.getBusinessId()!;
  @override
  int getBranchId() => ProxyService.box.getBranchId()!;
  @override
  String getUserPhone() => ProxyService.box.getUserPhone()!;
  @override
  String getDefaultApp() => ProxyService.box.getDefaultApp() ?? "POS";
  @override
  FutureOr<Pin?> getPinLocal(
          {required int userId, required bool alwaysHydrate}) =>
      ProxyService.strategy
          .getPinLocal(userId: userId, alwaysHydrate: alwaysHydrate);
  @override
  dynamic getEventService() => ProxyService.event;
  @override
  dynamic getBoxService() => ProxyService.box;
  @override
  dynamic getStrategyService() => ProxyService.strategy;

  @override
  void triggerHapticFeedback() {
    HapticFeedback.mediumImpact();
  }
}

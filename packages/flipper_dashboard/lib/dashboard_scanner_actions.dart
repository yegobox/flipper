import 'dart:async';

import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_services/event_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flipper_models/db_model_export.dart'; // For Product
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScannerActions implements ScannerActions {
  final BuildContext context;
  final WidgetRef ref;

  DashboardScannerActions(this.context, this.ref);

  @override
  void onBarcodeDetected(barcode) {
    ProxyService.productService.setBarcode(barcode.rawValue);
    Future.delayed(Duration(milliseconds: 500), () {
      pop();
    });
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
  Future<void> handleLoginScan(String? result) async {
    throw UnimplementedError();
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
  EventService getEventService() =>
      EventService(userId: getUserId().toString());
  @override
  dynamic getBoxService() => ProxyService.box;
  @override
  dynamic getStrategyService() => ProxyService.strategy;

  @override
  void triggerHapticFeedback() {
    HapticFeedback.mediumImpact();
  }
}

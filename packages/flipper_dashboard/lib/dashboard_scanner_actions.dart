import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_scanner/qr_login_scan_handler.dart';
import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_scanner/scanner_beep.dart';
import 'package:flipper_services/event_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DashboardScannerActions implements ScannerActions {
  final BuildContext context;
  final WidgetRef ref;

  Timer? _autoPop;
  bool _isClosed = false;
  QrLoginScanHandler? _qrLoginHandler;

  DashboardScannerActions(this.context, this.ref);

  QrLoginScanHandler get _loginHandler =>
      _qrLoginHandler ??= QrLoginScanHandler(this, ref);

  @override
  void onBarcodeDetected(Barcode barcode) async {
    final code = barcode.rawValue;
    if (code != null && code.startsWith('login-')) {
      await handleLoginScan(code);
      return;
    }

    try {
      ProxyService.productService.setBarcode(code);
      await ScannerBeep.playSuccess();
    } catch (e) {
      // Continue even if sound fails
    }

    _autoPop?.cancel();
    _autoPop = Timer(const Duration(milliseconds: 500), pop);
  }

  @override
  Future<void> handleLoginScan(String? result) async {
    await _loginHandler.handleLoginScan(result);
  }

  void dispose() {
    _autoPop?.cancel();
    _autoPop = null;
    _qrLoginHandler?.dispose();
    _qrLoginHandler = null;
  }

  @override
  Future<void> handleSellingScan(String? code) async {
    Product? product = await ProxyService.productService.getProductByBarCode(
      code: code,
    );
    if (product != null) {
      navigateToSellRoute(product);
      return;
    }
    showSimpleNotification("Product not found");
    _autoPop?.cancel();
    _autoPop = Timer(const Duration(milliseconds: 100), pop);
  }

  @override
  void pop() {
    if (_isClosed) return;

    _autoPop?.cancel();
    _autoPop = null;

    if (!Navigator.canPop(context)) return;

    _isClosed = true;
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
  String getUserId() => ProxyService.box.getUserId()!;
  @override
  String getBusinessId() => ProxyService.box.getBusinessId()!;
  @override
  String getBranchId() => ProxyService.box.getBranchId()!;
  @override
  String getUserPhone() => ProxyService.box.getUserPhone()!;
  @override
  String getDefaultApp() => ProxyService.box.getDefaultApp() ?? "POS";
  @override
  FutureOr<Pin?> getPinLocal({
    required String userId,
    required bool alwaysHydrate,
  }) => ProxyService.strategy.getPinLocal(
    userId: userId,
    alwaysHydrate: alwaysHydrate,
  );
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
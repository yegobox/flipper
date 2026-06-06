import 'dart:async';

import 'package:flipper_dashboard/transaction_item_adder.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_scanner/scanner_beep.dart';
import 'package:flipper_services/event_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CheckoutScannerActions extends ScannerActions {
  final BuildContext context;
  final WidgetRef ref;

  CheckoutScannerActions(this.context, this.ref);

  @override
  void onBarcodeDetected(Barcode barcode) async {
    if (barcode.rawValue == null) {
      showCustomSnackBarUtil(
        context,
        'No barcode value detected.',
        backgroundColor: Colors.red,
      );
      return;
    }

    showCustomSnackBarUtil(context, 'Processing barcode: ${barcode.rawValue}');

    try {
      Variant? variant = await ProxyService.strategy.getVariant(
        bcd: barcode.rawValue!,
      );

        if (variant != null) {
        final itemAdder = TransactionItemAdder(context, ref);
        await itemAdder.addItemToTransaction(
          variant: variant,
          isOrdering: false,
        );
        await ScannerBeep.playSuccess();
      } else {
        showCustomSnackBarUtil(
          context,
          'Product not found for barcode: ${barcode.rawValue}',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      showCustomSnackBarUtil(
        context,
        'Error adding product: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    } finally {
      pop();
    }
  }

  @override
  void pop() {
    Navigator.of(context).pop();
  }

  @override
  Future<void> handleLoginScan(String? result) async {
    // Not relevant for checkout scanner.
  }

  @override
  EventService getEventService() {
    throw UnimplementedError();
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
  String getDefaultApp() => ProxyService.box.getDefaultApp() ?? "1";

  @override
  void showSimpleNotification(String message) {
    showCustomSnackBarUtil(context, message);
  }

  @override
  getBoxService() {
    throw UnimplementedError();
  }

  @override
  FutureOr<Pin?> getPinLocal({
    required String userId,
    required bool alwaysHydrate,
  }) => ProxyService.strategy.getPinLocal(
    userId: userId,
    alwaysHydrate: alwaysHydrate,
  );

  @override
  getStrategyService() {
    throw UnimplementedError();
  }

  @override
  Future<void> handleSellingScan(String? code) {
    throw UnimplementedError();
  }

  @override
  void triggerHapticFeedback() {}

  @override
  void navigateToSellRoute(product) {}
}

import 'dart:async';

import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
// To refresh transaction items
import 'package:flipper_dashboard/transaction_item_adder.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pubnub/pubnub.dart' as nub;

class CheckoutScannerActions extends ScannerActions {
  final BuildContext context;
  final WidgetRef ref; // To interact with Riverpod

  CheckoutScannerActions(this.context, this.ref);

  @override
  void onBarcodeDetected(Barcode barcode) async {
    if (barcode.rawValue == null) {
      showCustomSnackBarUtil(context, 'No barcode value detected.',
          backgroundColor: Colors.red);
      return;
    }

    showCustomSnackBarUtil(context, 'Processing barcode: ${barcode.rawValue}');

    try {
      // Find the variant by barcode
      Variant? variant = await ProxyService.strategy.getVariant(
        bcd: barcode.rawValue!,
      );

      if (variant != null) {
        // Use the shared TransactionItemAdder
        final itemAdder = TransactionItemAdder(context, ref);
        await itemAdder.addItemToTransaction(
          variant: variant,
          isOrdering: false,
        );
      } else {
        showCustomSnackBarUtil(
            context, 'Product not found for barcode: ${barcode.rawValue}',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      showCustomSnackBarUtil(context, 'Error adding product: ${e.toString()}',
          backgroundColor: Colors.red);
    } finally {
      // Pop the scanner view after processing
      Navigator.of(context).pop();
    }
  }

  @override
  void pop() {
    Navigator.of(context).pop();
  }

  // Implement other abstract methods from ScannerActions if necessary,
  // or leave them as no-ops if not relevant for this specific use case.
  @override
  Future<void> handleLoginScan(String? result) async {
    // Not relevant for checkout scanner, can be a no-op or throw an error
  }

  @override
  nub.PubNub getEventService() {
    throw UnimplementedError();
  }

  @override
  int getUserId() {
    throw UnimplementedError();
  }

  @override
  int getBusinessId() {
    throw UnimplementedError();
  }

  @override
  int getBranchId() {
    throw UnimplementedError();
  }

  @override
  String getUserPhone() {
    throw UnimplementedError();
  }

  @override
  String getDefaultApp() {
    throw UnimplementedError();
  }

  @override
  void showSimpleNotification(String message) {
    showCustomSnackBarUtil(context, message);
  }

  @override
  getBoxService() {
    // TODO: implement getBoxService
    throw UnimplementedError();
  }

  @override
  FutureOr<Pin?> getPinLocal(
      {required int userId, required bool alwaysHydrate}) {
    // TODO: implement getPinLocal
    throw UnimplementedError();
  }

  @override
  getStrategyService() {
    // TODO: implement getStrategyService
    throw UnimplementedError();
  }

  @override
  Future<void> handleSellingScan(String? code) {
    // TODO: implement handleSellingScan
    throw UnimplementedError();
  }

  @override
  void triggerHapticFeedback() {
    // TODO: implement triggerHapticFeedback
  }

  @override
  void navigateToSellRoute(product) {
    // TODO: implement navigateToSellRoute
  }
}

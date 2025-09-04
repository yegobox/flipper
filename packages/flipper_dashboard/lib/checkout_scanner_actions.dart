import 'dart:async';

import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/event_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
// To refresh transaction items
import 'package:flipper_dashboard/transaction_item_adder.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_soloud/flutter_soloud.dart'; // Added for sound playback
import 'dart:io';

class CheckoutScannerActions extends ScannerActions {
  final BuildContext context;
  final WidgetRef ref; // To interact with Riverpod

  SoLoud? _soloud; // SoLoud instance
  AudioSource? _soundSource; // Sound source for barcode detection

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
      // Initialize SoLoud only on mobile platforms
      if ((Platform.isAndroid || Platform.isIOS) && _soloud == null) {
        _soloud = SoLoud.instance;
        await _soloud!.init();
        // Load the sound asset. Ensure 'assets/sound.mp3' exists in your project.
        // You might need to copy 'sound.mp3' to the 'assets' folder of flipper_dashboard package.
        _soundSource = await _soloud!
            .loadAsset('packages/flipper_dashboard/assets/sound.mp3');
      }

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
        // Play sound on successful barcode detection (mobile only)
        if ((Platform.isAndroid || Platform.isIOS) && _soundSource != null) {
          await _soloud!.play(_soundSource!);
        }
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
      // Use the pop() method to ensure SoLoud resources are properly disposed
      pop();
    }
  }

  @override
  void pop() {
    // Dispose SoLoud resources when the scanner view is popped (mobile only)
    if ((Platform.isAndroid || Platform.isIOS) && _soloud != null) {
      if (_soundSource != null) {
        _soloud!.disposeSource(_soundSource!);
        _soundSource = null;
      }
      _soloud!.deinit();
      _soloud = null;
    }
    Navigator.of(context).pop();
  }

  // Implement other abstract methods from ScannerActions if necessary,
  // or leave them as no-ops if not relevant for this specific use case.
  @override
  Future<void> handleLoginScan(String? result) async {
    // Not relevant for checkout scanner, can be a no-op or throw an error
  }

  @override
  EventService getEventService() {
    throw UnimplementedError();
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
  String getDefaultApp() => ProxyService.box.getDefaultApp() ?? "1";

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
          {required int userId, required bool alwaysHydrate}) =>
      ProxyService.strategy
          .getPinLocal(userId: userId, alwaysHydrate: alwaysHydrate);

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

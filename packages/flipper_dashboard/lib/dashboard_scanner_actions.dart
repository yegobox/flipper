import 'dart:async';

import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_services/event_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flipper_models/db_model_export.dart'; // For Product
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'dart:io';

class DashboardScannerActions implements ScannerActions {
  final BuildContext context;
  final WidgetRef ref;

  SoLoud? _soloud;
  AudioSource? _soundSource;
  Timer? _autoPop;
  bool _isClosed = false;

  DashboardScannerActions(this.context, this.ref);

  @override
  void onBarcodeDetected(barcode) async {
    try {
      // Initialize SoLoud only on mobile platforms
      if ((Platform.isAndroid || Platform.isIOS) && _soloud == null) {
        _soloud = SoLoud.instance;
        await _soloud!.init();
        _soundSource = await _soloud!
            .loadAsset('packages/flipper_dashboard/assets/sound.mp3');
      }

      ProxyService.productService.setBarcode(barcode.rawValue);
      
      // Play sound on successful barcode detection (mobile only)
      if ((Platform.isAndroid || Platform.isIOS) && _soundSource != null) {
        await _soloud!.play(_soundSource!);
      }
    } catch (e) {
      // Continue even if sound fails
    }
    
    _autoPop?.cancel();
    _autoPop = Timer(Duration(milliseconds: 500), () {
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
    _autoPop?.cancel();
    _autoPop = Timer(Duration(milliseconds: 100), () {
      pop();
    });
  }

  @override
  void pop() {
    if (_isClosed) return;
    
    _autoPop?.cancel();
    _autoPop = null;
    
    if (!Navigator.canPop(context)) return;
    
    _isClosed = true;
    
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
  
  void dispose() {
    _autoPop?.cancel();
    _autoPop = null;
    if ((Platform.isAndroid || Platform.isIOS) && _soloud != null) {
      if (_soundSource != null) {
        _soloud!.disposeSource(_soundSource!);
        _soundSource = null;
      }
      _soloud!.deinit();
      _soloud = null;
    }
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

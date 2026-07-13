import 'dart:async';

import 'package:flipper_scanner/providers/scan_status_provider.dart';
import 'package:flipper_scanner/qr_login_scan_handler.dart';
import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_services/event_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_auth/features/totp/providers/providers/totp_notifier.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flipper_models/db_model_export.dart';

class AuthScannerActions implements ScannerActions {
  final BuildContext context;
  final WidgetRef ref;

  QrLoginScanHandler? _qrLoginHandler;

  AuthScannerActions(this.context, this.ref);

  QrLoginScanHandler get _loginHandler =>
      _qrLoginHandler ??= QrLoginScanHandler(this, ref);

  @override
  void onBarcodeDetected(Barcode? barcode) {
    final String? code = barcode?.rawValue;
    if (code != null && code.startsWith('otpauth://')) {
      _handleTotpScan(code);
    } else if (code != null && code.startsWith('login-')) {
      unawaited(_loginHandler.handleLoginScan(code));
    } else {
      ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      showSimpleNotification('Invalid QR code');
      Timer(const Duration(seconds: 2), pop);
    }
  }

  Future<void> _handleTotpScan(String uri) async {
    try {
      ref.read(scanStatusProvider.notifier).state = ScanStatus.processing;

      final Uri parsedUri = Uri.parse(uri);
      if (parsedUri.scheme != 'otpauth' || parsedUri.host != 'totp') {
        throw const FormatException('Invalid TOTP URI');
      }

      final secret = parsedUri.queryParameters['secret'];
      final issuer = parsedUri.queryParameters['issuer'];
      final path = parsedUri.path.substring(1);
      final parts = path.split(':');
      final String accountName;
      final String finalIssuer;

      if (parts.length > 1) {
        finalIssuer = issuer ?? parts[0];
        accountName = parts.sublist(1).join(':').trim();
      } else {
        finalIssuer = issuer ?? 'Unknown Issuer';
        accountName = path.trim();
      }

      if (secret == null) {
        throw const FormatException('Secret not found in URI');
      }

      final account = {
        'issuer': finalIssuer,
        'account_name': accountName,
        'secret': secret,
      };

      final notifier = ref.read(totpNotifierProvider.notifier);
      await notifier.addAccount(account);

      ref.read(scanStatusProvider.notifier).state = ScanStatus.success;
      showSimpleNotification('Account added successfully');
      Timer(const Duration(seconds: 1), pop);
    } catch (e) {
      ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      showSimpleNotification('Failed to add account: ${e.toString()}');
      Timer(const Duration(seconds: 2), pop);
    }
  }

  @override
  Future<void> handleLoginScan(String? result) async {
    await _loginHandler.handleLoginScan(result);
  }

  @override
  Future<void> handleSellingScan(String? code) async {
    // Not used for auth intent
  }

  @override
  void pop() {
    _qrLoginHandler?.dispose();
    Navigator.of(context).pop();
  }

  @override
  void navigateToSellRoute(product) {
    throw UnimplementedError(
        'navigateToSellRoute not implemented in AuthScannerActions');
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
  String getDefaultApp() => ProxyService.box.getDefaultApp() ?? "1";
  @override
  FutureOr<Pin?> getPinLocal(
          {required String userId, required bool alwaysHydrate}) =>
      ProxyService.strategy
          .getPinLocal(alwaysHydrate: alwaysHydrate, userId: userId);
  @override
  EventService getEventService() => ProxyService.event as EventService;
  @override
  dynamic getBoxService() => throw UnimplementedError();
  @override
  dynamic getStrategyService() => throw UnimplementedError();

  @override
  void triggerHapticFeedback() {
    HapticFeedback.mediumImpact();
  }
}

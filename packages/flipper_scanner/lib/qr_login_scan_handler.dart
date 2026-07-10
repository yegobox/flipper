import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_scanner/providers/scan_status_provider.dart';
import 'package:flipper_scanner/random.dart';
import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared phone-side QR desktop login flow (dashboard + auth scanners).
class QrLoginScanHandler {
  QrLoginScanHandler(this.actions, this.ref);

  final ScannerActions actions;
  final WidgetRef ref;

  Timer? _desktopResponseTimeout;
  dynamic _responseObserver;
  bool _responseHandled = false;

  void dispose() {
    _desktopResponseTimeout?.cancel();
    _desktopResponseTimeout = null;
    final observer = _responseObserver;
    _responseObserver = null;
    if (observer != null) {
      unawaited(Future<void>.value(observer.cancel()));
    }
  }

  Future<void> handleLoginScan(String? result) async {
    if (result == null ||
        !result.contains('-') ||
        !result.split('-')[0].contains('login')) {
      ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      actions.showSimpleNotification('Invalid QR code format');
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      actions.pop();
      return;
    }

    final split = result.split('-');
    if (split.length <= 1 || split[0] != 'login') return;

    ref.read(scanStatusProvider.notifier).state = ScanStatus.processing;
    await _publishLoginDetails(split[1]);
  }

  Future<void> _publishLoginDetails(String channel) async {
    try {
      await _ensureMobileDittoForQrLogin();

      final userId = actions.getUserId();
      final linkingCode = randomNumber().toString();
      final responseChannel = 'login-response-$userId-$linkingCode';

      _listenForLoginResponse(responseChannel);

      final pin = await actions.getPinLocal(userId: userId, alwaysHydrate: false);

      await DittoService.instance.ensureEventsChannelSubscription(channel);
      await DittoService.instance.ensureBroadEventsCloudSubscription();

      await ProxyService.event.publish(loginDetails: {
        'channel': channel,
        'userId': userId,
        'businessId': actions.getBusinessId(),
        'branchId': actions.getBranchId(),
        'phone': actions.getUserPhone(),
        'defaultApp': actions.getDefaultApp(),
        'tokenUid': pin?.tokenUid,
        'pin': pin?.pin,
        'deviceName': Platform.operatingSystem,
        'deviceVersion': Platform.operatingSystemVersion,
        'linkingCode': linkingCode,
        'responseChannel': responseChannel,
      });

      ref.read(scanStatusProvider.notifier).state =
          ScanStatus.waitingForDesktop;
      _startDesktopResponseTimeout();
    } catch (e) {
      ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      actions.showSimpleNotification('Login error: ${e.toString()}');
      await Future<void>.delayed(const Duration(milliseconds: 2000));
      actions.pop();
    }
  }

  void _startDesktopResponseTimeout() {
    _desktopResponseTimeout?.cancel();
    _desktopResponseTimeout = Timer(const Duration(seconds: 90), () {
      if (_responseHandled) return;
      _responseHandled = true;
      ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      actions.showSimpleNotification(
        'Desktop did not respond — check it is on the QR login screen',
      );
      dispose();
      Future<void>.delayed(const Duration(seconds: 2), actions.pop);
    });
  }

  Future<void> _ensureMobileDittoForQrLogin() async {
    if (!DittoService.instance.isReady()) {
      throw StateError('Ditto not initialized — cannot send QR login event');
    }

    if (!DittoService.instance.dittoInstance!.sync.isActive) {
      DittoService.instance.startSync();
    }

    final syncDeadline = DateTime.now().add(const Duration(seconds: 15));
    while (DateTime.now().isBefore(syncDeadline)) {
      if (DittoService.instance.dittoInstance!.sync.isActive) break;
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    if (!DittoService.instance.dittoInstance!.sync.isActive) {
      throw StateError('Ditto sync not active — QR login event would stay local');
    }

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline =
        connectivity.any((result) => result != ConnectivityResult.none);
    if (!isOnline) return;

    // P2P may deliver the event on LAN without cloud; only wait briefly.
    final cloudDeadline = DateTime.now().add(const Duration(seconds: 5));
    while (DateTime.now().isBefore(cloudDeadline)) {
      if (DittoService.instance.isCloudReady()) return;
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }

  void _listenForLoginResponse(String responseChannel) {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) {
      throw StateError('Ditto not initialized');
    }

    final preparedEv = prepareDqlSyncSubscription(
      'SELECT * FROM events WHERE channel = :channel',
      {'channel': responseChannel},
    );
    ditto.sync.registerSubscription(
      preparedEv.dql,
      arguments: preparedEv.arguments,
    );

    _responseObserver = ditto.store.registerObserver(
      'SELECT * FROM events WHERE channel = :channel',
      arguments: {'channel': responseChannel},
      onChange: (queryResult) {
        if (_responseHandled) return;
        for (final item in queryResult.items) {
          final response = Map<String, dynamic>.from(item.value);
          if (!response.containsKey('status')) continue;
          _handleDesktopLoginResponse(response);
          return;
        }
      },
    );
  }

  void _handleDesktopLoginResponse(Map<String, dynamic> response) {
    if (_responseHandled) return;
    _responseHandled = true;
    _desktopResponseTimeout?.cancel();

    final status = response['status']?.toString();
    if (status == 'success' || status == 'choices_needed') {
      ref.read(scanStatusProvider.notifier).state =
          ScanStatus.desktopLoginSuccess;
      actions.triggerHapticFeedback();
      actions.showSimpleNotification(
        status == 'choices_needed'
            ? 'Desktop logged in — select your business there'
            : 'Desktop login successful',
      );
      dispose();
      Timer(const Duration(seconds: 2), actions.pop);
      return;
    }

    ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
    final errorMessage =
        response['message']?.toString() ?? 'Desktop login failed';
    actions.showSimpleNotification(errorMessage);
    dispose();
    Timer(const Duration(seconds: 2), actions.pop);
  }
}

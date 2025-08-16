import 'dart:async';
import 'dart:io';

import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pubnub/pubnub.dart' as nub;
import 'package:flipper_scanner/providers/scan_status_provider.dart';
import 'package:flipper_scanner/random.dart';
import 'package:flutter/services.dart'; // Added for HapticFeedback

class AuthScannerActions implements ScannerActions {
  final BuildContext context;
  final Ref ref;

  AuthScannerActions(this.context, this.ref);

  @override
  void onBarcodeDetected(barcode) {
    // Not used for auth intent
  }

  @override
  Future<void> handleLoginScan(String? result) async {
    // If there's no result or it doesn't match the login format, show error
    if (result == null ||
        !result.contains('-') ||
        !result.split('-')[0].contains('login')) {
      ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      showSimpleNotification('Invalid QR code format');

      // Wait a moment to show error state before closing
      Future.delayed(Duration(milliseconds: 1500)).then((_) {
        pop();
      });
      return;
    }

    final split = result.split('-');
    if (split.length > 1 && split[0] == 'login') {
      // Check if we have network connectivity
      Connectivity().checkConnectivity().then((connectivityResult) {
        if (connectivityResult == ConnectivityResult.none) {
          // We're offline, show a specific message
          ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
          showSimpleNotification(
              'Cannot login via QR when offline. Please use PIN login instead.');

          // Wait a moment to show error state before closing
          Future.delayed(Duration(milliseconds: 2000)).then((_) {
            pop();
          });
        } else {
          // We're online, proceed with login
          _publishLoginDetails(split[1]);
        }
      });
    }
  }

  @override
  Future<void> handleSellingScan(String? code) async {
    // Not used for auth intent
  }

  @override
  void pop() {
    Navigator.of(context).pop();
  }

  @override
  void navigateToSellRoute(product) {
    // Not used for auth intent
    throw UnimplementedError(
        'navigateToSellRoute not implemented in AuthScannerActions');
  }

  @override
  void showSimpleNotification(String message) {
    // showToast(context, message);
  }

  // Private methods moved from scanner_view.dart
  Future<void> _publishLoginDetails(String channel) async {
    // Vibrate on successful scan
    // HapticFeedback.mediumImpact(); // HapticFeedback is in flutter/services.dart, not accessible here

    try {
      int userId = getUserId();
      int businessId = getBusinessId();
      int branchId = getBranchId();
      String phone = getUserPhone();
      String defaultApp = getDefaultApp();
      String linkingCode = randomNumber().toString();

      // Create a unique response channel for this login attempt
      String responseChannel = 'login-response-${userId}-${linkingCode}';

      // Start listening for response on the response channel
      _listenForLoginResponse(responseChannel);

      // Update UI to show we're processing
      ref.read(scanStatusProvider.notifier).state = ScanStatus.processing;

      // get the pin
      final pin = await getPinLocal(userId: userId, alwaysHydrate: false);

      nub.PublishResult result = await getEventService().publish(loginDetails: {
        'channel': channel,
        'userId': userId,
        'businessId': businessId,
        'branchId': branchId,
        'phone': phone,
        'defaultApp': defaultApp,
        'tokenUid': pin?.tokenUid,
        'deviceName': Platform.operatingSystem,
        'deviceVersion': Platform.operatingSystemVersion,
        'linkingCode': linkingCode,
        'responseChannel': responseChannel, // Add response channel
      });

      if (result.isError) {
        // Only handle publish error here, success will be handled by response
        ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
        showSimpleNotification('Failed to send login request');

        // Wait a moment to show failure state before closing
        await Future.delayed(Duration(milliseconds: 1500));
        pop();
      }

      // Set up a timeout timer that will be canceled if we get a response
      Timer(Duration(seconds: 15), () {
        // Only proceed if we're still processing
        if (ref.read(scanStatusProvider) == ScanStatus.processing) {
          ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
          showSimpleNotification('Login timed out. Please try again.');

          // Wait a moment to show failure state before closing
          Timer(Duration(milliseconds: 1500), () {
            pop();
          });

          // Clean up subscription since we're done
          // _loginResponseSubscription?.unsubscribe(); // _loginResponseSubscription is not accessible here
          // _loginResponseSubscription = null;
        }
      });
    } catch (e) {
      // Handle any exceptions
      ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      showSimpleNotification('Login error: ${e.toString()}');

      // Wait a moment to show failure state before closing
      await Future.delayed(Duration(milliseconds: 1500));
      pop();
    }
  }

  void _listenForLoginResponse(String responseChannel) {
    try {
      // Use the connect method to get the PubNub instance
      nub.PubNub pubNub = getEventService().connect();

      // Subscribe to the response channel
      // _loginResponseSubscription = pubNub.subscribe(channels: {responseChannel}); // _loginResponseSubscription is not accessible here

      // Listen for messages on this channel
      pubNub.subscribe(channels: {responseChannel}).messages.listen((envelope) {
            // Parse the response
            Map<String, dynamic> response = envelope.payload;

            if (response.containsKey('status')) {
              if (response['status'] == 'success') {
                // Update UI to show success
                ref.read(scanStatusProvider.notifier).state =
                    ScanStatus.success;
                // HapticFeedback.lightImpact(); // HapticFeedback is in flutter/services.dart, not accessible here
                showSimpleNotification('Login successful');

                // Wait a moment to show success state before closing
                Future.delayed(Duration(milliseconds: 1500)).then((_) {
                  pop();
                });
              } else if (response['status'] == 'choices_needed') {
                // This is not a failure - it's part of the normal flow when a user
                // needs to select a business/branch
                ref.read(scanStatusProvider.notifier).state =
                    ScanStatus.success;
                // HapticFeedback.lightImpact(); // HapticFeedback is in flutter/services.dart, not accessible here
                showSimpleNotification(
                    'Login successful - select your business');

                // Wait a moment to show success state before closing
                Future.delayed(Duration(milliseconds: 1500)).then((_) {
                  pop();
                });
              } else {
                // Update UI to show failure
                ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;

                String errorMessage = response.containsKey('message')
                    ? response['message']
                    : 'Login failed';

                showSimpleNotification(errorMessage);

                // Wait a moment to show failure state before closing
                Future.delayed(Duration(milliseconds: 1500)).then((_) {
                  pop();
                });
              }

              // Cancel the timeout timer since we got a response
              // _loginTimeoutTimer?.cancel(); // _loginTimeoutTimer is not accessible here
              // _loginTimeoutTimer = null;

              // Unsubscribe after receiving response
              // _loginResponseSubscription?.unsubscribe(); // _loginResponseSubscription is not accessible here
              // _loginResponseSubscription = null;
            }
          }, onError: (error) {
            // Handle subscription error
            ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
            showSimpleNotification('Connection error: $error');

            // Wait a moment to show failure state before closing
            Future.delayed(Duration(milliseconds: 1500)).then((_) {
              pop();
            });
          });
    } catch (e) {
      // Handle any exceptions
      ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      showSimpleNotification('Subscription error: $e');

      // Wait a moment to show failure state before closing
      Future.delayed(Duration(milliseconds: 1500)).then((_) {
        pop();
      });
    }
  }

  @override
  int getUserId() => throw UnimplementedError();
  @override
  int getBusinessId() => throw UnimplementedError();
  @override
  int getBranchId() => throw UnimplementedError();
  @override
  String getUserPhone() => throw UnimplementedError();
  @override
  String getDefaultApp() => throw UnimplementedError();
  @override
  FutureOr<Pin?> getPinLocal(
          {required int userId, required bool alwaysHydrate}) =>
      throw UnimplementedError();
  @override
  dynamic getEventService() => throw UnimplementedError();
  @override
  dynamic getBoxService() => throw UnimplementedError();
  @override
  dynamic getStrategyService() => throw UnimplementedError();

  @override
  void triggerHapticFeedback() {
    HapticFeedback.mediumImpact();
  }
}

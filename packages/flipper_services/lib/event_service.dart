import 'dart:async';
import 'dart:developer';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_interface.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_services/proxy.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_event.dart';
import 'dart:io';
import 'package:flipper_services/desktop_login_status.dart';

LoginData loginDataFromMap(String str) => LoginData.fromMap(json.decode(str));

String loginDataToMap(LoginData data) => json.encode(data.toMap());

/// list of channels and their purposes
/// [LOGIN] this channel is used to send login details to other end
/// [logout] this channel is used to send logout details to other end
/// [device] this channel is used to send device details to other end

class EventService
    with TokenLogin, CoreMiscellaneous
    implements EventInterface {
  final String userId;

  @override
  DittoService get dittoService => DittoService.instance;

  // Event handling streams
  final StreamController<Map<String, dynamic>> _eventController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Desktop login state stream controller
  final _desktopLoginStatusController =
      StreamController<DesktopLoginStatus>.broadcast();

  @override
  Stream<DesktopLoginStatus> desktopLoginStatusStream() =>
      _desktopLoginStatusController.stream;

  @override
  void resetLoginStatus() {
    _desktopLoginStatusController
        .add(DesktopLoginStatus(DesktopLoginState.idle));
  }

  EventService({required this.userId}) {
    _desktopLoginStatusController
        .add(DesktopLoginStatus(DesktopLoginState.idle));
    _setupEventObservation();
  }

  Future<void> _setupEventObservation() async {
    try {
      // Set up observation for events collection
      // This is a simplified implementation - in a real scenario you'd use ditto's live queries
      // For now, we'll use a polling mechanism similar to the user profiles
      final pollingInterval = const Duration(seconds: 2);
      Timer.periodic(pollingInterval, (_) async {
        await _checkForNewEvents();
      });
    } catch (e) {
      talker.error('Error setting up event observation: $e');
    }
  }

  Future<void> _checkForNewEvents() async {
    try {
      // Query ditto for all events and emit them
      final events = await DittoService.instance
          .getEvents('*', '*'); // Get all events for now
      for (final event in events) {
        _eventController.add(event);
      }
    } catch (e) {
      talker.error('Error checking for new events: $e');
    }
  }

  @override
  Future<void> saveEvent(
      String channel, String eventType, Map<String, dynamic> data) async {
    try {
      final eventId =
          '${channel}_${eventType}_${DateTime.now().millisecondsSinceEpoch}';
      await DittoService.instance.saveEvent({
        'channel': channel,
        'type': eventType,
        'data': data,
      }, eventId);
      talker.debug('Event saved: $eventId');
    } catch (e) {
      talker.error('Error saving event: $e');
    }
  }

  Stream<Map<String, dynamic>> subscribeToEvents(
      {required String channel, required String eventType}) {
    // Return a stream that filters events by channel and type
    return _eventController.stream.where(
        (event) => event['channel'] == channel && event['type'] == eventType);
  }

  @override
  DittoService connect() {
    return dittoService;
  }

  @override
  Future<void> publish({required Map loginDetails}) async {
    try {
      // Store the event in ditto
      final channel = loginDetails['channel'] ?? 'default';
      final eventType = loginDetails['type'] ?? 'broadcast';
      await saveEvent(
          channel, eventType, Map<String, dynamic>.from(loginDetails));
    } catch (e) {
      talker.error('Error publishing event with ditto: $e');
    }
  }

  @override
  void subscribeToLogoutEvent({required String channel}) {
    try {
      // Set up a live query to listen for logout events in the specified channel
      subscribeToEvents(channel: channel, eventType: 'logout')
          .listen((event) async {
        LoginData loginData = LoginData.fromMap(event);
        if (ProxyService.box.getUserId() != null &&
            loginData.userId == ProxyService.box.getUserId()) {
          ///TODO: work on making sure only specific device with specific linkingCode
          ///is the one logged out not all device, but leaving it now as it is not top priority
          await FirebaseAuth.instance.signOut();
          logOut();
          // Note: _routerService navigation removed - handle this differently or inject the service
        }
      });
    } catch (e, stacktrace) {
      talker.error('Error subscribing to logout events: $e');
      talker.error(stacktrace);
    }
  }

  @override
  Stream<bool> isLoadingStream({bool? isLoading}) async* {
    // Emit the value received as parameter
    yield isLoading ?? false;
  }

  @override
  void subscribeLoginEvent({required String channel}) {
    try {
      // Set up a live query to listen for login events in the specified channel
      subscribeToEvents(channel: channel, eventType: 'login')
          .listen((event) async {
        _desktopLoginStatusController
            .add(DesktopLoginStatus(DesktopLoginState.loading));
        try {
          LoginData loginData = LoginData.fromMap(event);

          // Store the response channel for sending status updates back to mobile device
          String? responseChannel = loginData.responseChannel;

          ProxyService.box
              .writeInt(key: 'businessId', value: loginData.businessId);
          // ProxyService.box.writeString(key: 'uid', value: loginData.uid);
          ProxyService.box.writeInt(key: 'branchId', value: loginData.branchId);
          ProxyService.box.writeInt(key: 'userId', value: loginData.userId);
          ProxyService.box
              .writeString(key: 'userPhone', value: loginData.phone);
          ProxyService.box
              .writeString(key: 'defaultApp', value: loginData.defaultApp);

          // get the device name and version
          String deviceName = Platform.operatingSystem;

          // Get the device version.
          String deviceVersion = Platform.version;
          // publish the device name and version

          try {
            Device? device = await ProxyService.strategy.getDevice(
                phone: loginData.phone, linkingCode: loginData.linkingCode);
            if (device == null) {
              ProxyService.strategy.create(
                  data: Device(
                      pubNubPublished: false,
                      branchId: loginData.branchId,
                      businessId: loginData.businessId,
                      defaultApp: loginData.defaultApp,
                      phone: loginData.phone,
                      userId: loginData.userId,
                      linkingCode: loginData.linkingCode,
                      deviceName: deviceName,
                      deviceVersion: deviceVersion));
            }

            // Update local authentication
            await ProxyService.box.writeBool(key: 'isAnonymous', value: true);
            await ProxyService.box
                .writeBool(key: 'pinLogin', value: false); // QR login

            // Check if a PIN with this userId already exists in the local database
            final existingPin = await ProxyService.strategy
                .getPinLocal(userId: loginData.userId, alwaysHydrate: true);

            Pin thePin;
            if (existingPin != null) {
              // Update the existing PIN instead of creating a new one
              thePin = existingPin;

              // Update fields with the latest information
              thePin.phoneNumber = loginData.phone;
              thePin.branchId = loginData.branchId;
              thePin.businessId = loginData.businessId;
              thePin.tokenUid = loginData.tokenUid;

              talker.debug(
                  "Using existing PIN with userId: ${loginData.userId}, ID: ${thePin.id}");
            } else {
              // Create a new PIN if none exists
              thePin = Pin(
                  userId: loginData.userId,
                  pin: loginData.userId,
                  branchId: loginData.branchId,
                  businessId: loginData.businessId,
                  phoneNumber: loginData.phone,
                  tokenUid: loginData.tokenUid);
              talker.debug("Creating new PIN with userId: ${loginData.userId}");
            }

            // Use the standard login flow from auth_mixin
            await ProxyService.strategy.login(
              pin: thePin,
              isInSignUpProgress: false,
              flipperHttpClient: ProxyService.http,
              skipDefaultAppSetup: false,
              userPhone: loginData.phone,
            );

            // Verify userId is properly saved - this is critical for offline login to work later
            final savedUserId = ProxyService.box.getUserId();
            if (savedUserId == null || savedUserId != loginData.userId) {
              talker.debug(
                  "QR Login: userId not properly saved, explicitly setting it now");
              await ProxyService.box
                  .writeInt(key: 'userId', value: loginData.userId);
            } else {
              talker.debug("QR Login: userId properly saved: $savedUserId");
            }

            // Signal success to update the UI
            _desktopLoginStatusController
                .add(DesktopLoginStatus(DesktopLoginState.success));

            // Complete login first, then send success status
            try {
              await ProxyService.strategy.completeLogin(thePin);

              // Send success status back to the mobile device if response channel is provided
              if (responseChannel != null) {
                await publish(loginDetails: {
                  'channel': responseChannel,
                  'status': 'success',
                  'message': 'Login successful',
                });
                talker.debug(
                    "Sent login success response to channel: $responseChannel");
              }
            } catch (completeLoginError) {
              talker.error('Failed to complete login: $completeLoginError');

              // Send error status if we have a response channel
              if (responseChannel != null) {
                try {
                  await publish(loginDetails: {
                    'channel': responseChannel,
                    'status': 'error',
                    'message': 'Failed to complete login',
                  });
                } catch (responseError) {
                  talker.error('Failed to send error response: $responseError');
                }
              }
            }

            // Note: Navigation is handled by the standard login flow in auth_mixin.dart
            // which will properly handle business and branch choices if needed
          } catch (deviceError, stacktrace) {
            // Use centralized error handling with response channel
            await ProxyService.strategy.handleLoginError(
                deviceError, stacktrace,
                responseChannel: responseChannel);

            // Log the error but continue with login process
            talker.error('Device registration error: $deviceError');
          }
        } catch (e, stackTrace) {
          talker.error(e);
          // Show a user-friendly error message
          String errorMessage = 'Connection error. Please try again.';
          _desktopLoginStatusController.add(DesktopLoginStatus(
              DesktopLoginState.failure,
              message: errorMessage));

          // Extract response channel if possible and use centralized error handling
          try {
            Map<String, dynamic> payload = event;
            String? responseChannel = payload['responseChannel'];

            // Use centralized error handling with response channel
            if (responseChannel != null) {
              await ProxyService.strategy.handleLoginError(e, stackTrace,
                  responseChannel: responseChannel);
            }
          } catch (extractError) {
            talker.error('Failed to extract response channel: $extractError');
          }
        }
      });
    } catch (e) {
      talker.error(e);
      String errorMessage = 'Connection error. Please try again.';
      _desktopLoginStatusController.add(
          DesktopLoginStatus(DesktopLoginState.failure, message: errorMessage));
    }
  }

  /// listen to device event

  @override
  void subscribeToMessages({required String channel}) {
    try {
      // Set up a live query to listen for messages in the specified channel
      subscribeToEvents(channel: channel, eventType: 'message')
          .listen((event) async {
        log("received message via ditto!");
        // Process the message as needed
        // helper.IConversation conversation = helper.IConversation.fromJson(event.payload);
      });
    } catch (e) {
      talker.error('Error subscribing to messages: $e');
    }
  }

  @override
  void subscribeToDeviceEvent({required String channel}) {
    try {
      // Set up a live query to listen for device events in the specified channel
      subscribeToEvents(channel: channel, eventType: 'device')
          .listen((event) async {
        LoginData deviceEvent = LoginData.fromMap(event);

        Device? device = await ProxyService.strategy.getDevice(
            phone: deviceEvent.phone, linkingCode: deviceEvent.linkingCode);

        if (device == null) {
          await ProxyService.strategy.create(
              data: Device(
                  pubNubPublished: true,
                  branchId: deviceEvent.branchId,
                  businessId: deviceEvent.businessId,
                  defaultApp: deviceEvent.defaultApp,
                  phone: deviceEvent.phone,
                  userId: deviceEvent.userId,
                  linkingCode: deviceEvent.linkingCode,
                  deviceName: deviceEvent.deviceName,
                  deviceVersion: deviceEvent.deviceVersion));
        }
      });
    } catch (e) {
      talker.error('Error subscribing to device events: $e');
    }
  }
}

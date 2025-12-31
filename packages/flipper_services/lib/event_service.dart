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
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';

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

  // Observer for real-time event updates
  dynamic _eventObserver;
  // Observer for login-specific updates (per-channel)
  dynamic _loginObserver;

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
      // Set up real-time observation for events collection using Ditto observer
      if (DittoService.instance.isReady()) {
        await _setupRealtimeObservation();
      } else {
        // Fallback to polling if Ditto is not ready yet
        _setupPollingObservation();
      }
    } catch (e) {
      talker.error('Error setting up event observation: $e');
      // Fallback to polling on error
      _setupPollingObservation();
    }
  }

  Future<void> _setupRealtimeObservation() async {
    try {
      // Cancel any existing observer
      await _eventObserver?.cancel();

      // Register observer for all events
      _eventObserver =
          DittoService.instance.dittoInstance!.store.registerObserver(
        "SELECT * FROM events ORDER BY timestamp DESC",
        onChange: (queryResult) {
          // Emit all events to the stream
          for (final item in queryResult.items) {
            final event = Map<String, dynamic>.from(item.value);
            if (!_eventController.isClosed) {
              _eventController.add(event);
            }
          }
        },
      );

      talker.debug('Real-time event observation set up successfully');
    } catch (e) {
      talker.error(
          'Error setting up real-time observation, falling back to polling: $e');
      _setupPollingObservation();
    }
  }

  void _setupPollingObservation() {
    try {
      // Set up observation for events collection using polling as fallback
      final pollingInterval = const Duration(seconds: 2);
      Timer.periodic(pollingInterval, (_) async {
        await _checkForNewEvents();
      });
      talker.debug('Polling-based event observation set up as fallback');
    } catch (e) {
      talker.error('Error setting up polling observation: $e');
    }
  }

  Future<void> _checkForNewEvents() async {
    try {
      // Check if Ditto is ready before attempting to get events
      if (!DittoService.instance.isReady()) {
        // Ditto not initialized yet, skip this poll cycle
        return;
      }

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
      // Check if Ditto is ready before attempting to save events
      if (!DittoService.instance.isReady()) {
        talker.warning(
            'Ditto not initialized yet, cannot save event. Event will be lost.');
        return;
      }

      await DittoService.instance.saveEvent({
        'channel': channel,
        'type': eventType,
        'data': data,
      }, channel);
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
      // Store the event in ditto - for response events, don't nest the data
      final channel = loginDetails['channel'] ?? 'default';
      final eventType = loginDetails['type'] ?? 'broadcast';

      // For response events (success/error), save the data directly without nesting
      if (loginDetails.containsKey('status')) {
        await DittoService.instance
            .saveEvent(Map<String, dynamic>.from(loginDetails), channel);
      } else {
        // For other events, use the nested structure
        await saveEvent(
            channel, eventType, Map<String, dynamic>.from(loginDetails));
      }
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
      talker.debug('Subscribing to login events for channel $channel');
      // Cancel any existing login observer
      _loginObserver?.cancel();
      // Subscribe to sync events for this specific channel, excluding successful responses
      DittoService.instance.dittoInstance!.sync.registerSubscription(
          "SELECT * FROM events WHERE channel = :channel AND (status IS NULL OR status IS MISSING OR status != 'success')",
          arguments: {"channel": channel});

      // Use the global event stream to catch both local changes and synced data
      // Exclude events marked as logged out
      _loginObserver = _eventController.stream
          .where((event) =>
              event['channel'] == channel &&
              event['loggedOut'] != true &&
              event['status'] != 'success')
          .listen((event) {
        _processLoginEvent(event, channel);
      });

      talker.debug(
          'Login observer registered for channel $channel using global stream');
    } catch (e) {
      talker.error('Error subscribing to login events: $e');
      String errorMessage = 'Connection error. Please try again.';
      _desktopLoginStatusController.add(
          DesktopLoginStatus(DesktopLoginState.failure, message: errorMessage));
    }
  }

  // Helper to process a login/broadcast event (extracted from the previous
  // stream-based listener to keep logic in one place).
  Future<void> _processLoginEvent(
      Map<String, dynamic> event, String channel) async {
    LoginData? loginData;
    String? responseChannel;

    try {
      talker
          .debug('Received login/broadcast event for channel $channel: $event');
      _desktopLoginStatusController
          .add(DesktopLoginStatus(DesktopLoginState.loading));

      loginData = LoginData.fromMap(event);
      responseChannel = loginData.responseChannel;

      // Store basic login data
      ProxyService.box
          .writeString(key: 'businessId', value: loginData.businessId);
      ProxyService.box.writeString(key: 'branchId', value: loginData.branchId);
      ProxyService.box.writeString(key: 'userId', value: loginData.userId);
      ProxyService.box.writeString(key: 'userPhone', value: loginData.phone);
      ProxyService.box
          .writeString(key: 'defaultApp', value: loginData.defaultApp);

      // Get device info
      final deviceName = Platform.operatingSystem;
      final deviceVersion = await getDeviceVersion();

      // Create or update device record
      final device = await ProxyService.strategy.getDevice(
          phone: loginData.phone, linkingCode: loginData.linkingCode);

      if (device == null) {
        await ProxyService.strategy.create(
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

      // Update authentication flags
      await ProxyService.box.writeBool(key: 'isAnonymous', value: true);
      await ProxyService.box
          .writeBool(key: 'pinLogin', value: false); // QR login

      // Get or create PIN
      final existingPin = await ProxyService.strategy
          .getPinLocal(userId: loginData.userId, alwaysHydrate: true);

      final Pin thePin;
      if (existingPin != null) {
        thePin = existingPin;
        // Update existing PIN with latest info
        thePin.phoneNumber = loginData.phone;
        thePin.branchId = loginData.branchId;
        thePin.businessId = loginData.businessId;
        thePin.tokenUid = loginData.tokenUid;
        talker.debug(
            "Using existing PIN with userId: ${loginData.userId}, ID: ${thePin.id}");
      } else {
        thePin = Pin(
            userId: loginData.userId,
            pin: loginData.pin,
            branchId: loginData.branchId,
            businessId: loginData.businessId,
            phoneNumber: loginData.phone,
            tokenUid: loginData.tokenUid);
        talker.debug("Creating new PIN with userId: ${loginData.userId}");
      }

      // Perform login (may throw LoginChoicesException)
      await ProxyService.strategy.login(
        pin: thePin,
        isInSignUpProgress: false,
        flipperHttpClient: ProxyService.http,
        skipDefaultAppSetup: false,
        userPhone: loginData.phone,
      );
      // Complete login and send success response
      await ProxyService.strategy.completeLogin(thePin);
    } on LoginChoicesException {
      _desktopLoginStatusController
          .add(DesktopLoginStatus(DesktopLoginState.success));

      // This is expected - rethrow to let auth_mixin handle navigation
      if (responseChannel != null) {
        await publish(loginDetails: {
          'channel': loginData?.channel,
          'status': 'success',
          'loggedOut': false,
          'message': 'Login successful',
        });
        talker
            .debug("Sent login success response to channel: $responseChannel");
      }
      await Future<void>.delayed(const Duration(seconds: 5));
      locator<RouterService>().navigateTo(LoginChoicesRoute());
    } catch (e) {
      talker.error('Login processing error: $e');

      // Determine error message and response channel
      String errorMessage = 'Connection error. Please try again.';
      final errorResponseChannel =
          responseChannel ?? event['responseChannel'] as String?;

      // Send error response if we have a channel
      if (errorResponseChannel != null) {
        try {
          await publish(loginDetails: {
            'channel': errorResponseChannel,
            'status': 'error',
            'message': errorMessage,
          });
        } catch (responseError) {
          talker.error('Failed to send error response: $responseError');
        }
      }

      // Update UI with failure status
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

  /// Dispose of resources
  void dispose() {
    _eventObserver?.cancel();
    _loginObserver?.cancel();
    _eventController.close();
    _desktopLoginStatusController.close();
  }
}

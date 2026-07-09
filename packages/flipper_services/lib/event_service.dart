import 'dart:async';
import 'dart:developer';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
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
  dynamic _loginSubscription;
  void Function(Ditto?)? _loginDittoListener;
  Timer? _loginPollingTimer;
  bool _loginObserverActive = false;
  final Set<String> _processedLoginEventIds = {};
  int _loginEmptyPollCount = 0;

  void _emitDesktopLoginStatus(DesktopLoginStatus status) {
    if (!_desktopLoginStatusController.isClosed) {
      _desktopLoginStatusController.add(status);
    }
  }

  Future<void> _publishLoginResponse({
    required String responseChannel,
    required String status,
    String? message,
  }) async {
    try {
      await publish(
        loginDetails: {
          'channel': responseChannel,
          'status': status,
          if (message != null) 'message': message,
          if (status == 'success') 'loggedOut': false,
        },
      );
      talker.debug(
        'Sent login $status response to channel: $responseChannel',
      );
    } catch (e) {
      talker.error('Failed to send login response: $e');
    }
  }

  @override
  Stream<DesktopLoginStatus> desktopLoginStatusStream() =>
      _desktopLoginStatusController.stream;

  @override
  void resetLoginStatus() {
    _emitDesktopLoginStatus(
      DesktopLoginStatus(DesktopLoginState.idle),
    );
  }

  EventService({required this.userId}) {
    _emitDesktopLoginStatus(
      DesktopLoginStatus(DesktopLoginState.idle),
    );
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
      _eventObserver = DittoService.instance.dittoInstance!.store
          .registerObserver(
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
        'Error setting up real-time observation, falling back to polling: $e',
      );
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
      final events = await DittoService.instance.getEvents(
        '*',
        '*',
      ); // Get all events for now
      for (final event in events) {
        _eventController.add(event);
      }
    } catch (e) {
      talker.error('Error checking for new events: $e');
    }
  }

  @override
  Future<void> saveEvent(
    String channel,
    String eventType,
    Map<String, dynamic> data,
  ) async {
    if (!DittoService.instance.isReady()) {
      throw StateError(
        'Ditto not initialized yet, cannot save event for channel $channel',
      );
    }

    final eventId = _uniqueEventDocId(channel);
    await DittoService.instance.saveEvent({
      'channel': channel,
      'type': eventType,
      'data': data,
    }, eventId);
    talker.debug('Event saved: $eventId (channel: $channel)');
  }

  String _uniqueEventDocId(String channel) =>
      '${channel}_${DateTime.now().millisecondsSinceEpoch}';

  Stream<Map<String, dynamic>> subscribeToEvents({
    required String channel,
    required String eventType,
  }) {
    // Return a stream that filters events by channel and type
    return _eventController.stream.where(
      (event) => event['channel'] == channel && event['type'] == eventType,
    );
  }

  @override
  DittoService connect() {
    return dittoService;
  }

  @override
  Future<void> publish({required Map loginDetails}) async {
    // Store the event in ditto - for response events, don't nest the data
    final channel = loginDetails['channel'] ?? 'default';
    final eventType = loginDetails['type'] ?? 'broadcast';

    // For response events (success/error), save the data directly without nesting
    if (loginDetails.containsKey('status')) {
      final eventId = _uniqueEventDocId(channel);
      await DittoService.instance.saveEvent(
        Map<String, dynamic>.from(loginDetails),
        eventId,
      );
      talker.debug('Published status event: $eventId (channel: $channel)');
      return;
    }

    // For other events, use the nested structure
    await saveEvent(
      channel,
      eventType,
      Map<String, dynamic>.from(loginDetails),
    );
  }

  @override
  void subscribeToLogoutEvent({required String channel}) {
    try {
      // Set up a live query to listen for logout events in the specified channel
      subscribeToEvents(channel: channel, eventType: 'logout').listen((
        event,
      ) async {
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
    talker.debug('Subscribing to login events for channel $channel');
    _teardownLoginEventSubscription(removeListener: true);

    // Use the listener pattern to wait for Ditto to be ready
    // The listener is called immediately with the current value (may be null)
    // and called again when Ditto becomes available
    _loginDittoListener = (ditto) {
      if (ditto != null) {
        talker.debug(
          'Ditto listener fired with non-null instance for channel $channel',
        );
        _doSubscribeLoginEvent(channel, ditto);
      } else {
        talker.debug(
          'Ditto listener fired with null instance, waiting for Ditto to initialize...',
        );
      }
    };
    DittoService.instance.addDittoListener(_loginDittoListener!);
  }

  @override
  void unsubscribeLoginEvent() {
    _teardownLoginEventSubscription(removeListener: true);
  }

  void _teardownLoginEventSubscription({required bool removeListener}) {
    _loginObserverActive = false;

    if (removeListener && _loginDittoListener != null) {
      DittoService.instance.removeDittoListener(_loginDittoListener!);
      _loginDittoListener = null;
    }

    _loginPollingTimer?.cancel();
    _loginPollingTimer = null;

    final loginObserver = _loginObserver;
    _loginObserver = null;
    if (loginObserver != null) {
      // Defer cancel so Ditto's native callback can finish without hitting a
      // closed internal StreamController ("Cannot add event after closing").
      scheduleMicrotask(() {
        unawaited(Future<void>.value(loginObserver.cancel()));
      });
    }

    final loginSubscription = _loginSubscription;
    _loginSubscription = null;
    try {
      loginSubscription?.cancel();
    } catch (e) {
      talker.warning('Error canceling login sync subscription: $e');
    }
  }

  /// Actually set up the login event subscription (called when Ditto is ready)
  void _doSubscribeLoginEvent(String channel, dynamic ditto) {
    unawaited(_doSubscribeLoginEventWhenCloudReady(channel, ditto));
  }

  Future<void> _doSubscribeLoginEventWhenCloudReady(
    String channel,
    dynamic ditto,
  ) async {
    try {
      if (!await _waitForLoginDittoCloudReady(channel, ditto)) {
        talker.error(
          'Ditto cloud replication not ready — cannot receive QR login events',
        );
        _emitDesktopLoginStatus(
          DesktopLoginStatus(
            DesktopLoginState.failure,
            message: 'Connection error. Please try again.',
          ),
        );
        return;
      }

      if (!identical(ditto, dittoService.dittoInstance)) {
        talker.debug(
          'Ditto instance replaced before login subscription for $channel',
        );
        return;
      }

      await _registerLoginEventObservation(channel, ditto);
    } catch (e) {
      talker.error('Error subscribing to login events: $e');
      _emitDesktopLoginStatus(
        DesktopLoginStatus(
          DesktopLoginState.failure,
          message: 'Connection error. Please try again.',
        ),
      );
    }
  }

  Future<bool> _waitForLoginDittoCloudReady(
    String channel,
    dynamic ditto, {
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (dittoService.isCloudReady()) return true;

    talker.debug(
      'Waiting for Ditto cloud replication before login channel $channel',
    );
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (!identical(ditto, dittoService.dittoInstance)) return false;
      if (dittoService.isCloudReady()) {
        talker.debug('Ditto cloud replication ready for QR login');
        return true;
      }
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    return dittoService.isCloudReady();
  }

  Future<void> _registerLoginEventObservation(
    String channel,
    dynamic ditto,
  ) async {
    try {
      // Clear previously processed events for new subscription
      _processedLoginEventIds.clear();
      _loginPollingTimer?.cancel();
      _loginEmptyPollCount = 0;

      // Subscribe to sync events for this specific channel
      final preparedLoginEv = prepareDqlSyncSubscription(
        "SELECT * FROM events WHERE channel = :channel",
        {"channel": channel},
      );
      _loginSubscription = ditto.sync.registerSubscription(
        preparedLoginEv.dql,
        arguments: preparedLoginEv.arguments,
      );

      talker.debug('Registered sync subscription for channel $channel');

      // Use a DEDICATED observer for this channel instead of the global stream
      // This ensures we directly watch for synced events
      _loginObserverActive = true;
      _loginObserver = ditto.store.registerObserver(
        "SELECT * FROM events WHERE channel = :channel",
        arguments: {"channel": channel},
        onChange: (queryResult) {
          if (!_loginObserverActive) return;
          talker.debug(
            'Login observer fired for channel $channel, items: ${queryResult.items.length}',
          );
          for (final item in queryResult.items) {
            final event = Map<String, dynamic>.from(item.value);
            _handleLoginEventDedup(event, channel);
          }
        },
      );

      // Also set up polling as backup since observers may not fire reliably
      _loginPollingTimer = Timer.periodic(const Duration(milliseconds: 500), (
        _,
      ) async {
        if (!_loginObserverActive) return;
        await _pollForLoginEvents(channel, ditto);
      });

      // Do an immediate poll
      _pollForLoginEvents(channel, ditto);

      talker.debug(
        'Login observer and polling registered for channel $channel',
      );
    } catch (e) {
      talker.error('Error subscribing to login events: $e');
      _emitDesktopLoginStatus(
        DesktopLoginStatus(
          DesktopLoginState.failure,
          message: 'Connection error. Please try again.',
        ),
      );
    }
  }

  /// Poll for login events in the specified channel
  Future<void> _pollForLoginEvents(String channel, dynamic ditto) async {
    if (!_loginObserverActive) return;
    try {
      final result = await ditto.store.execute(
        "SELECT * FROM events WHERE channel = :channel",
        arguments: {"channel": channel},
      );

      final count = result.items.length;
      if (count == 0) {
        _loginEmptyPollCount++;
        // Log only occasionally to avoid spamming the console in debug builds.
        // (First time, then every ~minute at a 2s polling interval.)
        if (_loginEmptyPollCount == 1 || _loginEmptyPollCount % 30 == 0) {
          talker.debug('Polling found 0 events for channel $channel');
        }
        return;
      }

      // Reset once we see activity.
      _loginEmptyPollCount = 0;
      talker.debug('Polling found $count events for channel $channel');

      for (final item in result.items) {
        final event = Map<String, dynamic>.from(item.value);
        _handleLoginEventDedup(event, channel);
      }
    } catch (e) {
      talker.error('Error polling for login events: $e');
    }
  }

  Future<void> _markLoginEventConsumed(
    Map<String, dynamic> event,
    String channel,
  ) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;

    final eventId = event['_id']?.toString();
    try {
      if (eventId != null && eventId.isNotEmpty) {
        await ditto.store.execute(
          'UPDATE events SET loginConsumed = true WHERE _id = :id',
          arguments: {'id': eventId},
        );
      }
      await ditto.store.execute(
        "UPDATE events SET loginConsumed = true WHERE channel = :channel AND type = 'broadcast'",
        arguments: {'channel': channel},
      );
    } catch (e) {
      talker.warning('Failed to mark login event consumed: $e');
    }
  }

  /// Handle a login event with deduplication
  void _handleLoginEventDedup(Map<String, dynamic> event, String channel) {
    final eventId = event['_id']?.toString() ?? '';

    // Skip if already processed
    if (_processedLoginEventIds.contains(eventId)) return;

    // Skip if logged out or already used for a completed QR login
    if (event['loggedOut'] == true) return;
    if (event['loginConsumed'] == true) return;

    // Skip success responses (these are our own responses)
    if (event['status'] == 'success') return;

    talker.debug('Processing login event: $event');
    _processedLoginEventIds.add(eventId);

    unawaited(_markLoginEventConsumed(event, channel));

    // The QR login Ditto instance is temporary. Once we have the payload, tear
    // down its observer/subscription before the real login flow opens db2 and
    // starts app sync. Keeping both active caused debug-mode SQLite/Ditto stalls.
    _teardownLoginEventSubscription(removeListener: true);

    _processLoginEvent(event, channel);
  }

  // Helper to process a login/broadcast event (extracted from the previous
  // stream-based listener to keep logic in one place).
  Future<void> _processLoginEvent(
    Map<String, dynamic> event,
    String channel,
  ) async {
    LoginData? loginData;
    String? responseChannel;

    try {
      talker.debug(
        'Received login/broadcast event for channel $channel: $event',
      );
      _emitDesktopLoginStatus(
        DesktopLoginStatus(DesktopLoginState.loading),
      );

      loginData = LoginData.fromMap(event);
      responseChannel = loginData.responseChannel;

      // Store basic login data
      ProxyService.box.writeString(
        key: 'businessId',
        value: loginData.businessId,
      );
      ProxyService.box.writeString(key: 'branchId', value: loginData.branchId);
      ProxyService.box.writeString(key: 'userId', value: loginData.userId);
      ProxyService.box.writeString(key: 'userPhone', value: loginData.phone);
      ProxyService.box.writeString(
        key: 'defaultApp',
        value: loginData.defaultApp,
      );

      // Get device info
      final deviceName = Platform.operatingSystem;
      final deviceVersion = await getDeviceVersion();

      // Create or update device record
      Device? device = await ProxyService.strategy.getDevice(
        phone: loginData.phone,
        linkingCode: loginData.linkingCode,
      );

      if (device == null) {
        device = await ProxyService.strategy.create(
          data: Device(
            pubNubPublished: false,
            branchId: loginData.branchId,
            businessId: loginData.businessId,
            defaultApp: loginData.defaultApp,
            phone: loginData.phone,
            userId: loginData.userId,
            linkingCode: loginData.linkingCode,
            deviceName: deviceName,
            deviceVersion: deviceVersion,
          ),
        );
      }

      // QR login creates/updates a Device row but used to skip persisting
      // thisDeviceId locally. Post-login desktop registration then minted a
      // second UUID for the same physical machine.
      if (!Platform.isAndroid &&
          !Platform.isIOS &&
          device != null &&
          ProxyService.box.getThisDeviceId() == null) {
        await ProxyService.box.writeString(
          key: 'thisDeviceId',
          value: device.id,
        );
      }

      // Update authentication flags
      await ProxyService.box.writeBool(key: 'isAnonymous', value: true);
      await ProxyService.box.writeBool(
        key: 'pinLogin',
        value: false,
      ); // QR login

      // Get or create PIN
      final existingPin = await ProxyService.strategy.getPinLocal(
        userId: loginData.userId,
        alwaysHydrate: true,
      );

      final Pin thePin;
      if (existingPin != null) {
        thePin = existingPin;
        // Update existing PIN with latest info
        thePin.phoneNumber = loginData.phone;
        thePin.branchId = loginData.branchId;
        thePin.businessId = loginData.businessId;
        thePin.tokenUid = loginData.tokenUid;
        talker.debug(
          "Using existing PIN with userId: ${loginData.userId}, ID: ${thePin.id}",
        );
      } else {
        thePin = Pin(
          userId: loginData.userId,
          pin: loginData.pin,
          branchId: loginData.branchId,
          businessId: loginData.businessId,
          phoneNumber: loginData.phone,
          tokenUid: loginData.tokenUid,
        );
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

      _emitDesktopLoginStatus(
        DesktopLoginStatus(DesktopLoginState.success),
      );
      if (responseChannel != null) {
        await _publishLoginResponse(
          responseChannel: responseChannel,
          status: 'success',
          message: 'Login successful',
        );
      }
    } on LoginChoicesException {
      _emitDesktopLoginStatus(
        DesktopLoginStatus(DesktopLoginState.success),
      );

      if (responseChannel != null) {
        await _publishLoginResponse(
          responseChannel: responseChannel,
          status: 'choices_needed',
          message: 'Select your business on the desktop',
        );
      }
      locator<RouterService>().navigateTo(LoginChoicesRoute());
    } catch (e) {
      talker.error('Login processing error: $e');

      // Determine error message and response channel
      String errorMessage = 'Connection error. Please try again.';
      final errorResponseChannel =
          responseChannel ?? event['responseChannel'] as String?;

      // Send error response if we have a channel
      if (errorResponseChannel != null) {
        await _publishLoginResponse(
          responseChannel: errorResponseChannel,
          status: 'error',
          message: errorMessage,
        );
      }

      _emitDesktopLoginStatus(
        DesktopLoginStatus(DesktopLoginState.failure, message: errorMessage),
      );
    }
  }

  /// listen to device event

  @override
  void subscribeToMessages({required String channel}) {
    try {
      // Set up a live query to listen for messages in the specified channel
      subscribeToEvents(channel: channel, eventType: 'message').listen((
        event,
      ) async {
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
      subscribeToEvents(channel: channel, eventType: 'device').listen((
        event,
      ) async {
        LoginData deviceEvent = LoginData.fromMap(event);

        Device? device = await ProxyService.strategy.getDevice(
          phone: deviceEvent.phone,
          linkingCode: deviceEvent.linkingCode,
        );

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
              deviceVersion: deviceEvent.deviceVersion,
            ),
          );
        }
      });
    } catch (e) {
      talker.error('Error subscribing to device events: $e');
    }
  }

  /// Dispose of resources
  void dispose() {
    _eventObserver?.cancel();
    _teardownLoginEventSubscription(removeListener: true);
    _eventController.close();
    _desktopLoginStatusController.close();
  }
}

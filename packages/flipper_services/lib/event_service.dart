import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/event_interface.dart';
import 'package:pubnub/pubnub.dart' as nub;
import 'package:flipper_services/proxy.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'login_event.dart';
import 'dart:io';

LoginData loginDataFromMap(String str) => LoginData.fromMap(json.decode(str));

String loginDataToMap(LoginData data) => json.encode(data.toMap());

/// list of channels and their purposes
/// [login] this channel is used to send login details to other end
/// [logout] this channel is used to send logout details to other end
/// [device] this channel is used to send device details to other end
class EventService implements EventInterface {
  final _routerService = locator<RouterService>();
  nub.PubNub? pubnub;
  final keySet = nub.Keyset(
    subscribeKey: 'sub-c-2fb5f1f2-84dc-11ec-9f2b-a2cedba671e8',
    publishKey: 'pub-c-763b84f1-f366-4f07-b9db-3f626069e71c',
    uuid: const nub.UUID('5d012092-29c4-45fc-a37b-5776e64d4355'),
  );
  @override
  nub.PubNub connect() {
    pubnub = nub.PubNub(defaultKeyset: keySet);
    return pubnub!;
  }

  @override
  void publish({required Map loginDetails}) {
    if (pubnub == null) {
      connect();
    }
    final nub.Channel channel = pubnub!.channel(loginDetails['channel']);
    channel.publish(loginDetails);
  }

  @override
  void subscribeToLogoutEvent({required String channel}) {
    if (pubnub == null) {
      connect();
    }
    try {
      nub.Subscription subscription = pubnub!.subscribe(channels: {channel});
      subscription.messages.listen((envelope) async {
        LoginData loginData = LoginData.fromMap(envelope.payload);
        if (ProxyService.box.getUserId() != null &&
            loginData.userId == ProxyService.box.getUserId()) {
          ///TODO: work on making sure only specific device with specific linkingCode
          ///is the one logged out not all device, but leaving it now as it is not top priority
          await FirebaseAuth.instance.signOut();
          ProxyService.isarApi.logOut();
          _routerService.clearStackAndShow(LoginViewRoute());
        }
      });
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }

  @override
  Stream<bool> isLoadingStream({bool? isLoading}) async* {
    // Emit the value received as parameter
    yield isLoading ?? false;
  }

  @override
  void subscribeLoginEvent({required String channel}) {
    if (pubnub == null) {
      connect();
    }
    try {
      nub.Subscription subscription = pubnub!.subscribe(channels: {channel});
      subscription.messages.listen((envelope) async {
        isLoadingStream(isLoading: true);
        LoginData loginData = LoginData.fromMap(envelope.payload);

        await ProxyService.box
            .write(key: 'businessId', value: loginData.businessId);
        await ProxyService.box
            .write(key: 'branchId', value: loginData.branchId);
        await ProxyService.box.write(key: 'userId', value: loginData.userId);
        await ProxyService.box.write(key: 'userPhone', value: loginData.phone);
        await ProxyService.box
            .write(key: 'defaultApp', value: loginData.defaultApp);

        // get the device name and version
        String deviceName = Platform.operatingSystem;

        // Get the device version.
        String deviceVersion = Platform.version;
        // publish the device name and version

        Device? device = await ProxyService.isarApi
            .getDevice(linkingCode: loginData.linkingCode);

        if (device == null) {
          await ProxyService.isarApi.create(
              data: Device(
                  busienssId: loginData.businessId,
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
        await ProxyService.isarApi
            .login(userPhone: loginData.phone, skipDefaultAppSetup: true);
        keepTryingPublishDevice();
        await FirebaseAuth.instance.signInAnonymously();
      });
    } catch (e) {
      rethrow;
    }
  }

  /// listen to device event

  @override
  void subscribeToMessages({required String channel}) {
    if (pubnub == null) {
      connect();
    }
    log('subscribing to channel $channel');
    log('userId ${ProxyService.box.getUserId()}');
    nub.Subscription subscription = pubnub!.subscribe(channels: {channel});
    subscription.messages.listen((envelope) async {
      log("received message aha!");
      Conversation conversation = Conversation.fromJson(envelope.payload);

      Conversation? localConversation = await ProxyService.isarApi
          .getConversation(messageId: conversation.messageId!);

      if (localConversation == null) {
        await ProxyService.isarApi.create(data: conversation);
      }
    });
  }

  @override
  void subscribeToDeviceEvent({required String channel}) {
    if (pubnub == null) {
      connect();
    }
    log('subscribing to channel $channel');
    log('userId ${ProxyService.box.getUserId()}');
    nub.Subscription subscription = pubnub!.subscribe(channels: {channel});
    subscription.messages.listen((envelope) async {
      log("received device aha!");
      LoginData deviceEvent = LoginData.fromMap(envelope.payload);

      Device? device = await ProxyService.isarApi
          .getDevice(linkingCode: deviceEvent.linkingCode);

      if (device == null) {
        await ProxyService.isarApi.create(
            data: Device(
                busienssId: deviceEvent.businessId,
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
  }

  @override
  Future<void> keepTryingPublishDevice() async {
    if (ProxyService.box.getBusinessId() == null) return;
    List<Device> devices = await ProxyService.isarApi
        .unpublishedDevices(businessId: ProxyService.box.getBusinessId()!);
    for (Device device in devices) {
      publish(
        loginDetails: {
          'channel': 'device',
          'deviceName': device.deviceName,
          'deviceVersion': device.deviceVersion,
          'linkingCode': device.linkingCode,
          'userId': device.userId,
          'businessId': device.businessId,
          'branchId': device.branchId,
          'phone': device.phone,
          'defaultApp': device.defaultApp,
        },
      );
    }
  }
}

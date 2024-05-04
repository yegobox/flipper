import 'dart:developer';
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart' as isar;
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_interface.dart';
import 'package:pubnub/pubnub.dart' as nub;
import 'package:flipper_services/proxy.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:realm/realm.dart';
import 'package:stacked_services/stacked_services.dart';
import 'login_event.dart';
import 'dart:io';

LoginData loginDataFromMap(String str) => LoginData.fromMap(json.decode(str));

String loginDataToMap(LoginData data) => json.encode(data.toMap());

/// list of channels and their purposes
/// [LOGIN] this channel is used to send login details to other end
/// [logout] this channel is used to send logout details to other end
/// [device] this channel is used to send device details to other end
class EventService with TokenLogin implements EventInterface {
  final _routerService = locator<RouterService>();
  final nub.Keyset keySet;
  nub.PubNub? pubnub;

  EventService({required String userId})
      : keySet = nub.Keyset(
          subscribeKey: 'sub-c-2fb5f1f2-84dc-11ec-9f2b-a2cedba671e8',
          publishKey: 'pub-c-763b84f1-f366-4f07-b9db-3f626069e71c',
          userId: nub.UserId(userId),
        ) {
    pubnub = nub.PubNub(defaultKeyset: keySet);
  }

  @override
  nub.PubNub connect() {
    return pubnub!;
  }

  @override
  Future<nub.PublishResult> publish({required Map loginDetails}) async {
    if (pubnub == null) {
      connect();
    }
    final nub.Channel channel = pubnub!.channel(loginDetails['channel']);
    return await channel.publish(loginDetails);
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
          ProxyService.realm.logOut();
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
            .writeInt(key: 'businessId', value: loginData.businessId);
        await ProxyService.box.writeString(key: 'uid', value: loginData.uid);
        await ProxyService.box
            .writeInt(key: 'branchId', value: loginData.branchId);
        await ProxyService.box.writeInt(key: 'userId', value: loginData.userId);
        await ProxyService.box
            .writeString(key: 'userPhone', value: loginData.phone);
        await ProxyService.box
            .writeString(key: 'defaultApp', value: loginData.defaultApp);

        // get the device name and version
        String deviceName = Platform.operatingSystem;

        // Get the device version.
        String deviceVersion = Platform.version;
        // publish the device name and version

        Device? device = await ProxyService.realm.getDevice(
            phone: loginData.phone, linkingCode: loginData.linkingCode);
        try {
          await ProxyService.realm
              .login(userPhone: loginData.phone, skipDefaultAppSetup: true);
          if (device == null) {
            await ProxyService.realm.create(
                data: Device(ObjectId(),
                    id: randomNumber(),
                    pubNubPublished: false,
                    branchId: loginData.branchId,
                    businessId: loginData.businessId,
                    action: AppActions.created,
                    defaultApp: loginData.defaultApp,
                    phone: loginData.phone,
                    userId: loginData.userId,
                    linkingCode: loginData.linkingCode,
                    deviceName: deviceName,
                    deviceVersion: deviceVersion));
          }
          // await FirebaseAuth.instance.signInAnonymously();
          /// uid is token linked with the user
          await tokenLogin(loginData.uid);
          keepTryingPublishDevice();
        } catch (e) {}
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
      isar.IConversation conversation =
          isar.IConversation.fromJson(envelope.payload);

      Conversation? localConversation = await ProxyService.realm
          .getConversation(messageId: conversation.messageId!);

      if (localConversation == null) {
        await ProxyService.realm.create(data: conversation);
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
      LoginData deviceEvent = LoginData.fromMap(envelope.payload);

      Device? device = await ProxyService.realm.getDevice(
          phone: deviceEvent.phone, linkingCode: deviceEvent.linkingCode);

      if (device == null) {
        await ProxyService.realm.create(
            data: Device(ObjectId(),
                id: randomNumber(),
                pubNubPublished: true,
                action: AppActions.created,
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
    List<Device> devices = await ProxyService.realm
        .unpublishedDevices(businessId: ProxyService.box.getBusinessId()!);
    for (Device device in devices) {
      nub.PublishResult result = await publish(
        loginDetails: {
          'channel': ProxyService.box.getUserPhone()!.replaceAll("+", ""),
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
      if (result.description == 'Sent') {
        ProxyService.realm.realm!.writeAsync(() async {
          device.pubNubPublished = true;
        });
      }
    }
  }
}

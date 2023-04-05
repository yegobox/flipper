import 'package:flipper_services/event_interface.dart';
import 'package:pubnub/pubnub.dart' as nub;
import 'package:flipper_services/proxy.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_event.dart';

LoginData loginDataFromMap(String str) => LoginData.fromMap(json.decode(str));

String loginDataToMap(LoginData data) => json.encode(data.toMap());

class EventService implements EventInterface {
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
        if (loginData.userId == ProxyService.box.read(key: 'userId')) {
          await FirebaseAuth.instance.signOut();
          ProxyService.isarApi.logOut();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void subscribeLoginEvent({required String channel}) {
    if (pubnub == null) {
      connect();
    }
    try {
      nub.Subscription subscription = pubnub!.subscribe(channels: {channel});
      subscription.messages.listen((envelope) async {
        LoginData loginData = LoginData.fromMap(envelope.payload);

        ProxyService.box.write(key: 'businessId', value: loginData.businessId);
        ProxyService.box.write(key: 'branchId', value: loginData.branchId);
        ProxyService.box.write(key: 'userId', value: loginData.userId);
        ProxyService.box.write(key: 'userPhone', value: loginData.phone);
        await ProxyService.isarApi.login(
          userPhone: loginData.phone,
        );
        await FirebaseAuth.instance.signInAnonymously();
      });
    } catch (e) {
      rethrow;
    }
  }
}

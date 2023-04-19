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

LoginData loginDataFromMap(String str) => LoginData.fromMap(json.decode(str));

String loginDataToMap(LoginData data) => json.encode(data.toMap());

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
  void subscribeLoginEvent({required String channel}) {
    if (pubnub == null) {
      connect();
    }
    try {
      nub.Subscription subscription = pubnub!.subscribe(channels: {channel});
      subscription.messages.listen((envelope) async {
        LoginData loginData = LoginData.fromMap(envelope.payload);

        await ProxyService.box
            .write(key: 'businessId', value: loginData.businessId);
        await ProxyService.box
            .write(key: 'branchId', value: loginData.branchId);
        await ProxyService.box.write(key: 'userId', value: loginData.userId);
        await ProxyService.box.write(key: 'userPhone', value: loginData.phone);
        await ProxyService.box
            .write(key: 'defaultApp', value: loginData.defaultApp);

        await ProxyService.isarApi.login(
          userPhone: loginData.phone,
        );

        /// because in login.dart file we have this code
        /// if (snapshot.hasData) {
        ///  return const StartUpView(
        ///     invokeLogin: true,
        ///   );
        /// }
        /// the code is triggered when the user is logged in so no need to do another
        /// routing or redirecting here in case you want to know how it redirects
        /// to to mentioned file and see the code
        await FirebaseAuth.instance.signInAnonymously();
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void subscribeToMessages({required String channel}) {
    if (pubnub == null) {
      connect();
    }
    log('subscribing to channel $channel');
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
}

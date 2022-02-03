// Import all PubNub objects into your namespace
// import 'package:pubnub/core.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flutter/cupertino.dart';
// Or import PubNub into a named namespace
import 'package:pubnub/pubnub.dart' as nub;
// To parse this JSON data, do
//     final loginData = loginDataFromMap(jsonString);
import 'package:flipper_services/proxy.dart';
import 'dart:convert';
import 'package:flipper_routing/routes.router.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

LoginData loginDataFromMap(String str) => LoginData.fromMap(json.decode(str));

String loginDataToMap(LoginData data) => json.encode(data.toMap());

class LoginData {
  LoginData({
    required this.channel,
    required this.userId,
    required this.businessId,
    required this.branchId,
    required this.phone,
  });

  String channel;

  String userId;
  int businessId;
  int branchId;
  String phone;

  factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
        channel: json["channel"],
        userId: json["userId"],
        businessId: json["businessId"],
        branchId: json["branchId"],
        phone: json["phone"],
      );

  Map<String, dynamic> toMap() => {
        "channel": channel,
        "userId": userId,
        "businessId": businessId,
        "branchId": branchId,
        "phone": phone,
      };
}

class EventService {
  final log = getLogger('LoginService');
  late nub.PubNub pubnub;
  final keySet = nub.Keyset(
    subscribeKey: 'sub-c-2fb5f1f2-84dc-11ec-9f2b-a2cedba671e8',
    publishKey: 'pub-c-763b84f1-f366-4f07-b9db-3f626069e71c',
    uuid: const nub.UUID('5d012092-29c4-45fc-a37b-5776e64d4355'),
  );
  nub.PubNub connect() {
    pubnub = nub.PubNub(defaultKeyset: keySet);
    return pubnub;
  }

  void publish({required Map loginDetails}) {
    final nub.Channel channel = pubnub.channel(loginDetails['channel']);
    channel.publish(loginDetails);
  }

  void subscribePaymentEvent(
      {required String channel, required BuildContext context}) {}

  void subscribeLoginEvent(
      {required String channel, required BuildContext context}) {
    nub.Subscription subscription = pubnub.subscribe(channels: {channel});
    subscription.messages.listen((envelope) async {
      LoginData loginData = LoginData.fromMap(envelope.payload);
      // save login keys for logged in user
      await FirebaseAuth.instance.signInAnonymously();
      final auth = FirebaseAuth.instance;

      /// login anonymous user so we know this desktop! come online.
      if (auth.currentUser != null) {
        ProxyService.box.write(key: 'businessId', value: loginData.businessId);
        ProxyService.box.write(key: 'branchId', value: loginData.branchId);
        ProxyService.box.write(key: 'userId', value: loginData.userId);
        ProxyService.box.write(key: 'userPhone', value: loginData.phone);
        await ProxyService.api.login(
          userPhone: loginData.phone,
        );
        // ProxyService.nav.navigateTo(Routes.initial);
        GoRouter.of(context).go(Routes.boot);
      }
    });
  }
}

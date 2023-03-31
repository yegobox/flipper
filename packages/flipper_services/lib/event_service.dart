import 'package:flutter/cupertino.dart';
import 'package:pubnub/pubnub.dart' as nub;
import 'package:flipper_services/proxy.dart';
import 'dart:convert';
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

  void subscribeLoginEvent(
      {required String channel, required BuildContext context}) {
    try {
      nub.Subscription subscription = pubnub.subscribe(channels: {channel});
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

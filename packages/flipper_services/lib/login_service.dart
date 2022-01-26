// Import all PubNub objects into your namespace
// import 'package:pubnub/core.dart';
import 'package:flipper_routing/routes.logger.dart';
// Or import PubNub into a named namespace
import 'package:pubnub/pubnub.dart';
// To parse this JSON data, do
//
//     final loginData = loginDataFromMap(jsonString);
import 'package:flipper_services/proxy.dart';
import 'dart:convert';
import 'package:flipper_routing/routes.router.dart';
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

class LoginService {
  final log = getLogger('LoginService');
  late PubNub pubnub;
  final keySet = Keyset(
    subscribeKey: 'sub-c-9d0df480-67d5-11ec-a4f8-fa616d2d2ecf',
    publishKey: 'pub-c-ca33a9a4-b6c5-42fc-9edc-f15947d3178b',
    uuid: const UUID('5d012092-29c4-45fc-a37b-5776e64d4355'),
  );
  void connect() {
    pubnub = PubNub(defaultKeyset: keySet);
  }

  void publish({required Map loginDetails}) {
    final Channel channel = pubnub.channel(loginDetails['channel']);
    channel.publish(loginDetails);
  }

  void subscribe({required String channel}) {
    Subscription subscription = pubnub.subscribe(channels: {channel});
    subscription.messages.listen((envelope) async {
      LoginData loginData = LoginData.fromMap(envelope.payload);
      // save login keys for logged in user
      await FirebaseAuth.instance.signInAnonymously();
      final auth = FirebaseAuth.instance;

      /// login anonymous user so we know this desktop! come online.
      if (auth.currentUser != null) {
        // log.d(loginData.toMap());
        ProxyService.box.write(key: 'businessId', value: loginData.businessId);
        ProxyService.box.write(key: 'branchId', value: loginData.branchId);
        ProxyService.box.write(key: 'userId', value: loginData.userId);
        ProxyService.box.write(key: 'userPhone', value: loginData.phone);
        await ProxyService.api.login(
          userPhone: loginData.phone,
        );
        ProxyService.nav.navigateTo(Routes.initial);
      }
    });
  }
}

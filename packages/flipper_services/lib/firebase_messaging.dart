import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_services/proxy.dart';

abstract class Messaging {
  Future<void> init();
  Future<String?> token();
}

class FirebaseMessagingDesktop implements Messaging {
  @override
  Future<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<String> token() {
    // TODO: implement token
    throw UnimplementedError();
  }
}

class FirebaseMessagingService implements Messaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> init() async {
    await FirebaseMessaging.instance
        .subscribeToTopic(ProxyService.box.getBranchId()!.toString());
    String? _token = await token();
    ProxyService.remoteApi.create(collection: {
      "deviceToken": _token,
      "businessId": ProxyService.box.getBusinessId()!
    }, collectionName: 'messagings');
  }

  @override
  Future<String?> token() async {
    return await _firebaseMessaging.getToken();
  }
}

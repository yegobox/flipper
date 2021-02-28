library flipper_services;

import 'package:flipper_services/flipper_config.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pusher/pusher.dart';
import 'package:pusher_websocket_flutter/pusher.dart' as p;
import 'package:observable_ish/observable_ish.dart';

class PusherService {
  final RxValue<p.Event> pay = RxValue<p.Event>(initial: null);

  Future<void> subs() async {
    final FlipperConfig flipperConfig =
        await ProxyService.firestore.getConfigs();

    await p.Pusher.init(
        flipperConfig.pusherAppKey, p.PusherOptions(cluster: 'ap2'),
        enableLogging: true);
    p.Channel channel;
    p.Pusher.connect(onConnectionStateChange: (val) {
      print(val);
    }, onError: (err) {
      print(err);
    });
    channel =
        await p.Pusher.subscribe('channel.' + ProxyService.sharedState.user.id);
    channel.bind('event.' + ProxyService.sharedState.user.id, (event) {
      pay.value = null;
      pay.value = event;
    });
  }

  Future syncToClients() async {
    final FlipperConfig flipperConfig =
        await ProxyService.firestore.getConfigs();

    final Pusher pusher = Pusher(
        flipperConfig.pusherAppId,
        flipperConfig.pusherAppKey,
        flipperConfig.pusherAppSecret,
        PusherOptions(cluster: 'ap2'));
    final Map data = {'message': 'sync-clients'};
    //first sync is channel and the second is event
    try {
      await pusher.trigger(['sync'], 'sync', data);
      // ignore: empty_catches
    } catch (e) {} //in case of internet not available
  }
}

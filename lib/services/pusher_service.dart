import 'package:flipper/model/flipper_config.dart';
import 'package:flipper/services/proxy.dart';
import 'package:pusher/pusher.dart';

class PusherService {
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
    await pusher.trigger(['sync'], 'sync', data);
  }
}

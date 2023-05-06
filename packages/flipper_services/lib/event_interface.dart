import 'package:pubnub/pubnub.dart' as nub;

abstract class EventInterface {
  void publish({required Map loginDetails});
  void subscribeLoginEvent({required String channel});
  void subscribeToLogoutEvent({required String channel});
  nub.PubNub connect();
  void subscribeToMessages({required String channel});
  void subscribeToDeviceEvent({required String channel});
  Stream<bool> isLoadingStream({bool? isLoading});
  Future<void> keepTryingPublishDevice();
}

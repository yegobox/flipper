import 'package:pubnub/pubnub.dart';

abstract class EventInterface {
  Future<PublishResult> publish({required Map loginDetails});
  void subscribeLoginEvent({required String channel});
  void subscribeToLogoutEvent({required String channel});
  PubNub connect();
  void subscribeToMessages({required String channel});
  void subscribeToDeviceEvent({required String channel});
  Stream<bool> isLoadingStream({bool? isLoading});
  Future<void> keepTryingPublishDevice();
}

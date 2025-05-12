import 'package:flipper_services/desktop_login_status.dart'
    show DesktopLoginStatus;
import 'package:pubnub/pubnub.dart';

abstract class EventInterface {
  Future<PublishResult> publish({required Map loginDetails});
  void subscribeLoginEvent({required String channel});
  void subscribeToLogoutEvent({required String channel});
  PubNub connect();
  void subscribeToMessages({required String channel});
  void subscribeToDeviceEvent({required String channel});

  /// Emits login state for desktop login (idle, loading, success, failure, with optional message)
  Stream<DesktopLoginStatus> desktopLoginStatusStream();

  Stream<bool> isLoadingStream({bool? isLoading});
  Future<void> keepTryingPublishDevice();
}

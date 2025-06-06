import 'package:flipper_services/desktop_login_status.dart'
    show DesktopLoginStatus;
import 'package:pubnub/pubnub.dart';
import 'package:pubnub/pubnub.dart' as nub;

abstract class EventInterface {
  Future<PublishResult> publish({required Map loginDetails});
  void subscribeLoginEvent({required String channel});
  void subscribeToLogoutEvent({required String channel});
  PubNub connect();
  void subscribeToMessages({required String channel});
  void subscribeToDeviceEvent({required String channel});

  /// Emits login state for desktop login (idle, loading, success, failure, with optional message)
  Stream<DesktopLoginStatus> desktopLoginStatusStream();

  /// Resets the desktop login status to idle state
  void resetLoginStatus();

  Stream<bool> isLoadingStream({bool? isLoading});
  nub.PubNub? pubnub;
}

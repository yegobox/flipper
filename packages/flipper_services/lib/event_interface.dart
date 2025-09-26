import 'package:flipper_services/desktop_login_status.dart'
    show DesktopLoginStatus;
import 'package:flipper_web/services/ditto_service.dart';

abstract class EventInterface {
  Future<void> publish({required Map loginDetails});
  Future<void> saveEvent(
      String channel, String eventType, Map<String, dynamic> data);
  void subscribeLoginEvent({required String channel});
  void subscribeToLogoutEvent({required String channel});
  DittoService connect();
  void subscribeToMessages({required String channel});
  void subscribeToDeviceEvent({required String channel});

  /// Emits login state for desktop login (idle, loading, success, failure, with optional message)
  Stream<DesktopLoginStatus> desktopLoginStatusStream();

  /// Resets the desktop login status to idle state
  void resetLoginStatus();

  Stream<bool> isLoadingStream({bool? isLoading});
  DittoService get dittoService;
}

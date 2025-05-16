/// Shared types for desktop login state/status.

enum DesktopLoginState { idle, loading, success, failure }

class DesktopLoginStatus {
  final DesktopLoginState state;
  final String? message;
  const DesktopLoginStatus(this.state, {this.message});
}

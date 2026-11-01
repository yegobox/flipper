/// Whether the user's own Claude Code CLI can be used for Flo chat.
enum ClaudeCliState {
  /// Not a desktop platform, or the binary could not be launched.
  unavailable,

  /// The `claude` binary was not found.
  notInstalled,

  /// Installed but not signed in (`claude auth login` needed).
  notLoggedIn,

  /// Installed and signed in.
  ready,
}

class ClaudeCliStatus {
  const ClaudeCliStatus(this.state, {this.executable, this.account});

  static const unavailable = ClaudeCliStatus(ClaudeCliState.unavailable);

  final ClaudeCliState state;

  /// Absolute path of the resolved binary (when found).
  final String? executable;

  /// Signed-in account email, when the CLI reports one.
  final String? account;

  bool get isReady => state == ClaudeCliState.ready;
}

/// Raised when a Claude CLI run fails (non-zero exit, `is_error`, timeout…).
class ClaudeCliException implements Exception {
  const ClaudeCliException(this.message);
  final String message;

  @override
  String toString() => message;
}

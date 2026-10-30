import 'claude_cli_status.dart';
import 'claude_cli_runner_stub.dart'
    if (dart.library.io) 'claude_cli_runner_io.dart' as platform;

/// Talks to the user's locally installed Claude Code CLI, which is already
/// signed in to their own Claude subscription. Flipper never sees or stores
/// Claude credentials; the CLI does the authentication.
abstract class ClaudeCliRunner {
  /// Locate the binary and check the sign-in state.
  Future<ClaudeCliStatus> detect();

  /// Run one non-interactive turn and return the answer text.
  ///
  /// [prompt] is written to stdin (never argv) so business data does not show
  /// up in process listings. Throws [ClaudeCliException] on failure.
  Future<String> ask({
    required String executable,
    required String systemPrompt,
    required String prompt,
    Duration timeout,
  });
}

/// Process-wide runner; tests swap it for a fake.
class ClaudeCli {
  ClaudeCli._();

  static ClaudeCliRunner runner = platform.createRunner();

  static ClaudeCliStatus? _cached;

  /// Cached [ClaudeCliRunner.detect]; pass [refresh] after the user installs
  /// or signs in.
  static Future<ClaudeCliStatus> status({bool refresh = false}) async {
    if (!refresh && _cached != null) return _cached!;
    return _cached = await runner.detect();
  }
}

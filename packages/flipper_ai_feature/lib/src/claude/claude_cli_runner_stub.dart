import 'claude_cli_runner.dart';
import 'claude_cli_status.dart';

ClaudeCliRunner createRunner() => _UnsupportedRunner();

/// Web: no processes to spawn.
class _UnsupportedRunner implements ClaudeCliRunner {
  @override
  Future<ClaudeCliStatus> detect() async => ClaudeCliStatus.unavailable;

  @override
  Future<String> ask({
    required String executable,
    required String systemPrompt,
    required String prompt,
    Duration timeout = const Duration(minutes: 2),
  }) =>
      throw const ClaudeCliException('Claude CLI is not available here.');
}

import 'package:flipper_ai_feature/src/claude/claude_cli_runner.dart';
import 'package:flipper_ai_feature/src/claude/claude_cli_status.dart';
import 'package:flutter_test/flutter_test.dart';

class _CountingRunner implements ClaudeCliRunner {
  _CountingRunner(this.results);

  final List<ClaudeCliStatus> results;
  int detects = 0;

  @override
  Future<ClaudeCliStatus> detect() async => results[detects++];

  @override
  Future<String> ask({
    required String executable,
    required String systemPrompt,
    required String prompt,
    Duration timeout = const Duration(minutes: 2),
  }) async =>
      throw UnimplementedError();
}

void main() {
  test('status() caches detection until asked to refresh', () async {
    const ready =
        ClaudeCliStatus(ClaudeCliState.ready, executable: '/bin/claude');
    final runner = _CountingRunner([
      const ClaudeCliStatus(ClaudeCliState.notLoggedIn),
      ready,
    ]);
    ClaudeCli.runner = runner;

    final first = await ClaudeCli.status(refresh: true);
    final cached = await ClaudeCli.status();

    expect(first.state, ClaudeCliState.notLoggedIn);
    expect(identical(cached, first), isTrue);
    expect(runner.detects, 1);

    final refreshed = await ClaudeCli.status(refresh: true);
    expect(refreshed.isReady, isTrue);
    expect(refreshed.executable, '/bin/claude');
    expect(runner.detects, 2);
  });

  test('ClaudeCliStatus.isReady is true only for ready', () {
    for (final state in ClaudeCliState.values) {
      expect(ClaudeCliStatus(state).isReady, state == ClaudeCliState.ready);
    }
    expect(ClaudeCliStatus.unavailable.state, ClaudeCliState.unavailable);
  });

  test('ClaudeCliException prints its message', () {
    const e = ClaudeCliException('rate limited');
    expect(e.message, 'rate limited');
    expect(e.toString(), 'rate limited');
  });
}

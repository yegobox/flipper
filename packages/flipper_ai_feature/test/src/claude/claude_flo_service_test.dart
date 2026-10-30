import 'dart:convert';

import 'package:flipper_ai_feature/src/claude/claude_cli_runner.dart';
import 'package:flipper_ai_feature/src/claude/claude_cli_status.dart';
import 'package:flipper_ai_feature/src/claude/claude_output_parser.dart';
import 'package:flipper_ai_feature/src/services/claude_flo_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRunner implements ClaudeCliRunner {
  _FakeRunner(this.status, {this.answer, this.error});

  final ClaudeCliStatus status;
  final String? answer;
  final ClaudeCliException? error;
  String? lastPrompt;
  String? lastSystem;

  @override
  Future<ClaudeCliStatus> detect() async => status;

  @override
  Future<String> ask({
    required String executable,
    required String systemPrompt,
    required String prompt,
    Duration timeout = const Duration(minutes: 2),
  }) async {
    lastPrompt = prompt;
    lastSystem = systemPrompt;
    if (error != null) throw error!;
    return answer!;
  }
}

void main() {
  const service = ClaudeFloService();
  const ready =
      ClaudeCliStatus(ClaudeCliState.ready, executable: '/bin/claude');

  tearDown(() => ClaudeCli.runner = _FakeRunner(ClaudeCliStatus.unavailable));

  group('parseClaudeResult', () {
    test('returns the trimmed answer', () {
      expect(
        parseClaudeResult(
            '{"type":"result","is_error":false,"result":" hi \\n"}'),
        'hi',
      );
    });

    test('throws the CLI message on is_error', () {
      expect(
        () => parseClaudeResult(
            '{"type":"result","is_error":true,"result":"bad model"}'),
        throwsA(isA<ClaudeCliException>()
            .having((e) => e.message, 'message', 'bad model')),
      );
    });

    test('rejects non-JSON and non-result payloads', () {
      expect(
          () => parseClaudeResult('oops'), throwsA(isA<ClaudeCliException>()));
      expect(() => parseClaudeResult('{"type":"system"}'),
          throwsA(isA<ClaudeCliException>()));
    });
  });

  test('parseClaudeAuthStatus reads loggedIn and email', () {
    final ok = parseClaudeAuthStatus('{"loggedIn":true,"email":"a@b.co"}');
    expect(ok.loggedIn, isTrue);
    expect(ok.email, 'a@b.co');
    expect(parseClaudeAuthStatus('garbage').loggedIn, isFalse);
  });

  test('emits thinking, blocks and meta on success, with data in the prompt',
      () async {
    final runner = _FakeRunner(ready, answer: 'Revenue was RWF 5000.');
    ClaudeCli.runner = runner;

    final events = await service.streamChat(
      message: 'How did I do?',
      shopName: 'Kigali Shop',
      currency: 'RWF',
      deviceSales: {
        'period_label': 'today',
        'transaction_count': 2,
        'total_revenue': 5000,
      },
    ).toList();

    expect(
        events.map((e) => e.event), ['thinking', 'thinking', 'blocks', 'meta']);
    final blocks = jsonDecode(events[2].data) as List;
    expect(blocks.single['html'], 'Revenue was RWF 5000.');
    expect(runner.lastPrompt, contains('Kigali Shop'));
    expect(runner.lastPrompt, contains('RWF 5000'));
    expect(runner.lastPrompt, contains('User question: How did I do?'));
    expect(runner.lastSystem, contains('no tools'));
  });

  test('not installed / not signed in yield a single error event', () async {
    ClaudeCli.runner =
        _FakeRunner(const ClaudeCliStatus(ClaudeCliState.notInstalled));
    var events = await service.streamChat(message: 'x').toList();
    expect(events.single.event, 'error');
    expect(events.single.data, contains('Install Claude Code'));

    ClaudeCli.runner =
        _FakeRunner(const ClaudeCliStatus(ClaudeCliState.notLoggedIn));
    events = await service.streamChat(message: 'x').toList();
    expect(events.single.event, 'error');
    expect(events.single.data, contains('not signed in'));
  });

  test('a failed run surfaces as an error event', () async {
    ClaudeCli.runner =
        _FakeRunner(ready, error: const ClaudeCliException('rate limited'));
    final events = await service.streamChat(message: 'x').toList();
    expect(events.last.event, 'error');
    expect(events.last.data, contains('rate limited'));
  });
}

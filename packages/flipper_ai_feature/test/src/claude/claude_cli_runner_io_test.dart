import 'dart:io';

import 'package:flipper_ai_feature/src/claude/claude_cli_runner_io.dart';
import 'package:flipper_ai_feature/src/claude/claude_cli_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final skip = Platform.isWindows ? 'needs a POSIX shell' : null;
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('claude_runner_'));
  tearDown(() => dir.deleteSync(recursive: true));

  File stub(String body) {
    final f = File('${dir.path}/claude')..writeAsStringSync('#!/bin/sh\n$body');
    Process.runSync('chmod', ['+x', f.path]);
    return f;
  }

  test('prompt goes to stdin, never argv', () async {
    final script = stub('''
printf '%s\\n' "\$@" > "${dir.path}/argv"
cat > "${dir.path}/stdin"
printf '{"type":"result","is_error":false,"result":"ok"}'
''');
    const secret = 'TOP-SECRET-SHOP-FIGURES 12345';

    final out = await IoClaudeCliRunner().ask(
      executable: script.path,
      systemPrompt: 'Be terse.',
      prompt: secret,
    );

    expect(out, 'ok');
    expect(
        File('${dir.path}/argv').readAsStringSync(), isNot(contains(secret)));
    expect(File('${dir.path}/stdin').readAsStringSync(), contains(secret));
    expect(File('${dir.path}/argv').readAsStringSync(), contains('--tools'));
  }, skip: skip);

  test('tolerates malformed UTF-8 in output', () async {
    final script = stub('''
cat > /dev/null
printf '{"type":"result","is_error":false,"result":"caf\\351 ok"}'
''');

    final out = await IoClaudeCliRunner()
        .ask(executable: script.path, systemPrompt: 's', prompt: 'p');

    expect(out, endsWith('ok'));
  }, skip: skip);

  test('empty stdout surfaces stderr as an exception', () async {
    final script = stub('cat > /dev/null\necho boom >&2\nexit 3');

    expect(
      IoClaudeCliRunner()
          .ask(executable: script.path, systemPrompt: 's', prompt: 'p'),
      throwsA(isA<ClaudeCliException>()
          .having((e) => e.message, 'message', 'boom')),
    );
  }, skip: skip);

  test('times out and kills a hung CLI', () async {
    final script = stub('cat > /dev/null\nsleep 30');

    expect(
      IoClaudeCliRunner().ask(
        executable: script.path,
        systemPrompt: 's',
        prompt: 'p',
        timeout: const Duration(milliseconds: 300),
      ),
      throwsA(isA<ClaudeCliException>()),
    );
  }, skip: skip);
}

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
    final script = stub('cat > /dev/null\nexec sleep 30');

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

  group('detect', () {
    // Lays out `<home>/.local/bin/claude` answering `auth status --json`.
    String homeWithClaude(String authJson) {
      final bin = Directory('${dir.path}/home/.local/bin')
        ..createSync(recursive: true);
      final f = File('${bin.path}/claude')
        ..writeAsStringSync('#!/bin/sh\nprintf \'%s\' \'$authJson\'\n');
      Process.runSync('chmod', ['+x', f.path]);
      return '${dir.path}/home';
    }

    test('non-desktop platforms are unavailable', () async {
      final status = await IoClaudeCliRunner(isDesktop: false).detect();
      expect(status.state, ClaudeCliState.unavailable);
      expect(status.isReady, isFalse);
    });

    test('a signed-in CLI in ~/.local/bin is ready with its account', () async {
      final home = homeWithClaude('{"loggedIn":true,"email":"owner@shop.rw"}');

      final status = await IoClaudeCliRunner(
        homeOverride: home,
        environment: const {'PATH': ''},
      ).detect();

      expect(status.state, ClaudeCliState.ready);
      expect(status.isReady, isTrue);
      expect(status.executable, '$home/.local/bin/claude');
      expect(status.account, 'owner@shop.rw');
    }, skip: skip);

    test('a signed-out CLI reports notLoggedIn', () async {
      final home = homeWithClaude('{"loggedIn":false}');

      final status = await IoClaudeCliRunner(
        homeOverride: home,
        environment: const {'PATH': ''},
      ).detect();

      expect(status.state, ClaudeCliState.notLoggedIn);
      expect(status.account, isNull);
    }, skip: skip);

    test('no binary anywhere and no login shell is notInstalled', () async {
      final status = await IoClaudeCliRunner(
        homeOverride: '${dir.path}/empty-home',
        environment: {'PATH': '', 'SHELL': '${dir.path}/no-such-shell'},
        systemDirs: const [],
      ).detect();

      expect(status.state, ClaudeCliState.notInstalled);
      expect(status.executable, isNull);
    }, skip: skip);

    test('a binary that cannot be launched is unavailable', () async {
      final bin = Directory('${dir.path}/home/.local/bin')
        ..createSync(recursive: true);
      // Present but not executable: Process.start throws.
      File('${bin.path}/claude').writeAsStringSync('not a program');

      final status = await IoClaudeCliRunner(
        homeOverride: '${dir.path}/home',
        environment: const {'PATH': ''},
      ).detect();

      expect(status.state, ClaudeCliState.unavailable);
    }, skip: skip);
  });

  group('locateExecutable', () {
    test('falls back to PATH entries', () async {
      final onPath = Directory('${dir.path}/path-bin')..createSync();
      File('${onPath.path}/claude').writeAsStringSync('');

      final exe = await IoClaudeCliRunner(
        homeOverride: '',
        environment: {'PATH': '${dir.path}/missing:${onPath.path}'},
        systemDirs: const [],
      ).locateExecutable();

      expect(exe, '${onPath.path}/claude');
    }, skip: skip);

    test('asks a login shell when no known dir has it', () async {
      final hidden = Directory('${dir.path}/hidden')..createSync();
      File('${hidden.path}/claude').writeAsStringSync('');
      final shell = File('${dir.path}/fake-shell')
        ..writeAsStringSync(
            '#!/bin/sh\necho "motd noise"\necho "${hidden.path}/claude"\n');
      Process.runSync('chmod', ['+x', shell.path]);

      final exe = await IoClaudeCliRunner(
        homeOverride: '${dir.path}/empty-home',
        environment: {'PATH': '', 'SHELL': shell.path},
        systemDirs: const [],
      ).locateExecutable();

      expect(exe, '${hidden.path}/claude');
    }, skip: skip);

    test('ignores a login shell answer that is not a real file', () async {
      final shell = File('${dir.path}/fake-shell')
        ..writeAsStringSync('#!/bin/sh\necho "${dir.path}/gone/claude"\n');
      Process.runSync('chmod', ['+x', shell.path]);

      final exe = await IoClaudeCliRunner(
        homeOverride: '${dir.path}/empty-home',
        environment: {'PATH': '', 'SHELL': shell.path},
        systemDirs: const [],
      ).locateExecutable();

      expect(exe, isNull);
    }, skip: skip);
  });

  test('empty stdout and stderr reports the exit code', () async {
    final script = stub('cat > /dev/null\nexit 7');

    expect(
      IoClaudeCliRunner()
          .ask(executable: script.path, systemPrompt: 's', prompt: 'p'),
      throwsA(isA<ClaudeCliException>()
          .having((e) => e.message, 'message', contains('code 7'))),
    );
  }, skip: skip);

  test('createRunner returns the desktop runner', () {
    expect(createRunner(), isA<IoClaudeCliRunner>());
  });
}

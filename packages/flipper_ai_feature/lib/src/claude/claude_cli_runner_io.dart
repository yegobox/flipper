import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'claude_cli_runner.dart';
import 'claude_cli_status.dart';
import 'claude_output_parser.dart';

ClaudeCliRunner createRunner() => IoClaudeCliRunner();

/// Desktop implementation: spawns the user's `claude` binary.
///
/// The CLI is run with every tool, MCP server, skill and settings source
/// disabled, so it behaves as a plain question-answering model that cannot read
/// files or run commands on the user's machine.
class IoClaudeCliRunner implements ClaudeCliRunner {
  IoClaudeCliRunner({
    this.homeOverride,
    this.environment,
    this.systemDirs,
    this.isDesktop,
    this.isWindows,
    this.taskkill,
  });

  final String? homeOverride;

  /// Process environment (PATH, SHELL, HOME…); defaults to the real one.
  final Map<String, String>? environment;

  /// Fixed install dirs probed after the home ones; defaults per platform.
  final List<String>? systemDirs;

  /// Overrides the desktop-platform check; defaults to the host platform.
  final bool? isDesktop;

  /// Overrides the Windows check used to end a timed-out CLI.
  final bool? isWindows;

  /// The Windows tool that ends a process tree; tests point it at a stub.
  /// Defaults to the system copy, never one found earlier on PATH.
  final String? taskkill;

  /// How long taskkill may take before the direct kill is used instead.
  static const _taskkillTimeout = Duration(seconds: 5);

  bool get _onWindows => isWindows ?? Platform.isWindows;

  String get _taskkill =>
      taskkill ??
      '${Platform.environment['SystemRoot'] ?? r'C:\Windows'}'
          r'\System32\taskkill.exe';

  bool get _isDesktop =>
      isDesktop ?? (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  @override
  Future<ClaudeCliStatus> detect() async {
    if (!_isDesktop) return ClaudeCliStatus.unavailable;
    try {
      final exe = await locateExecutable();
      if (exe == null)
        return const ClaudeCliStatus(ClaudeCliState.notInstalled);

      final result = await _run(
        exe,
        const ['auth', 'status', '--json'],
        timeout: const Duration(seconds: 10),
      );
      final auth = parseClaudeAuthStatus(result.stdout);
      return ClaudeCliStatus(
        auth.loggedIn ? ClaudeCliState.ready : ClaudeCliState.notLoggedIn,
        executable: exe,
        account: auth.email,
      );
    } on Object {
      // Sandboxed builds can refuse to launch external binaries.
      return ClaudeCliStatus.unavailable;
    }
  }

  @override
  Future<String> ask({
    required String executable,
    required String systemPrompt,
    required String prompt,
    Duration timeout = const Duration(minutes: 2),
  }) async {
    final result = await _run(
      executable,
      [
        '-p',
        '--output-format',
        'json',
        '--no-session-persistence',
        '--tools',
        '',
        '--strict-mcp-config',
        '--disable-slash-commands',
        '--setting-sources',
        '',
        '--system-prompt',
        systemPrompt,
      ],
      stdin: prompt,
      timeout: timeout,
    );
    if (result.stdout.trim().isEmpty) {
      final err = result.stderr.trim();
      throw ClaudeCliException(
        err.isEmpty ? 'Claude exited with code ${result.exitCode}.' : err,
      );
    }
    return parseClaudeResult(result.stdout);
  }

  Future<({int exitCode, String stdout, String stderr})> _run(
    String executable,
    List<String> args, {
    String? stdin,
    required Duration timeout,
  }) async {
    final process = await Process.start(
      executable,
      args,
      // npm installs on Windows are `.cmd` shims.
      runInShell: Platform.isWindows && !executable.endsWith('.exe'),
      workingDirectory: Directory.systemTemp.path,
    );
    final out = process.stdout
        .transform(const Utf8Decoder(allowMalformed: true))
        .join();
    final err = process.stderr
        .transform(const Utf8Decoder(allowMalformed: true))
        .join();
    if (stdin != null) {
      process.stdin.write(stdin);
    }
    unawaited(process.stdin.close().catchError((Object _) {}));
    try {
      final code = await process.exitCode.timeout(timeout);
      return (exitCode: code, stdout: await out, stderr: await err);
    } on TimeoutException {
      await _end(process);
      throw const ClaudeCliException('Claude took too long to answer.');
    }
  }

  /// On Windows a `.cmd` shim runs under cmd.exe, and [Process.kill] ends
  /// only that wrapper: the Node CLI would keep running on the user's Claude
  /// subscription. End the whole tree there; elsewhere the CLI is the process.
  Future<void> _end(Process process) async {
    if (_onWindows) {
      try {
        final killer = await Process.start(
            _taskkill, ['/T', '/F', '/PID', '${process.pid}']);
        // A hung taskkill must not hang the timeout it is cleaning up after.
        final code =
            await killer.exitCode.timeout(_taskkillTimeout, onTimeout: () {
          killer.kill();
          return -1;
        });
        if (code == 0) return;
      } on ProcessException {
        // No taskkill: fall back to ending the direct process.
      }
    }
    process.kill();
  }

  /// GUI apps do not inherit the shell PATH, so probe the usual install
  /// locations before asking a login shell.
  Future<String?> locateExecutable() async {
    final env = environment ?? Platform.environment;
    final home = homeOverride ?? env['HOME'] ?? env['USERPROFILE'] ?? '';
    final names = _onWindows ? ['claude.exe', 'claude.cmd'] : ['claude'];
    final sep = Platform.pathSeparator;

    final dirs = <String>[
      if (home.isNotEmpty) ...[
        '$home${sep}.local${sep}bin',
        '$home${sep}.claude${sep}local',
        '$home${sep}.npm-global${sep}bin',
        '$home${sep}.bun${sep}bin',
        if (Platform.isWindows) '$home${sep}AppData${sep}Roaming${sep}npm',
      ],
      ...systemDirs ??
          [
            if (Platform.isMacOS) '/opt/homebrew/bin',
            if (!Platform.isWindows) '/usr/local/bin',
          ],
      ...(env['PATH'] ?? '')
          .split(Platform.isWindows ? ';' : ':')
          .where((d) => d.isNotEmpty),
    ];
    for (final dir in dirs) {
      for (final name in names) {
        final path = '$dir$sep$name';
        if (await File(path).exists()) return path;
      }
    }

    if (!Platform.isWindows) {
      try {
        final shell = env['SHELL'] ?? '/bin/zsh';
        final r = await Process.run(shell, ['-lc', 'command -v claude'])
            .timeout(const Duration(seconds: 5));
        final path = (r.stdout as String).trim().split('\n').last;
        if (r.exitCode == 0 && path.isNotEmpty && await File(path).exists()) {
          return path;
        }
      } on Object {
        // No login shell / timed out: treat as not installed.
      }
    }
    return null;
  }
}

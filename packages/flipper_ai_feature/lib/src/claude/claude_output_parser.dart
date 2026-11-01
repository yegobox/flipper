import 'dart:convert';

import 'claude_cli_status.dart';

/// Parses `claude -p --output-format json` stdout into the answer text.
///
/// Throws [ClaudeCliException] when the CLI reports an error result or the
/// output is not the expected JSON object.
String parseClaudeResult(String stdout) {
  final Object? decoded;
  try {
    decoded = jsonDecode(stdout.trim());
  } on FormatException {
    throw const ClaudeCliException('Claude returned an unreadable response.');
  }
  if (decoded is! Map || decoded['type'] != 'result') {
    throw const ClaudeCliException('Claude returned an unexpected response.');
  }
  final text = (decoded['result'] as String?)?.trim() ?? '';
  if (decoded['is_error'] == true) {
    throw ClaudeCliException(
      text.isEmpty ? 'Claude reported an error.' : text,
    );
  }
  return text;
}

/// Parses `claude auth status --json` into a signed-in flag and account.
({bool loggedIn, String? email}) parseClaudeAuthStatus(String stdout) {
  try {
    final decoded = jsonDecode(stdout.trim());
    if (decoded is Map) {
      return (
        loggedIn: decoded['loggedIn'] == true,
        email: decoded['email'] as String?,
      );
    }
  } on FormatException {
    // Fall through: treated as signed out.
  }
  return (loggedIn: false, email: null);
}

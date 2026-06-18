import 'dart:convert';

import 'dart:developer' as developer;

import 'package:flipper_models/helperModels/talker.dart';

/// Pretty, box-drawn HTTP logs for data-connector clients (imports/purchases, bulk RRA).
abstract final class DataConnectorHttpLog {
  static const _label = 'DATA-CONNECTOR HTTP';

  static void request({
    required String method,
    required Uri uri,
    String? body,
    Map<String, String>? headers,
    String? operation,
  }) {
    final b = StringBuffer()
      ..writeln('╔══ $_label ══ REQUEST ═══════════════════════');
    if (operation != null && operation.isNotEmpty) {
      b.writeln('║   op: $operation');
    }
    b
      ..writeln('║ ▶ $method ${_fullPath(uri)}')
      ..writeln('║   base: ${uri.scheme}://${uri.host}:${uri.port}');
    if (headers != null && headers.isNotEmpty) {
      for (final e in headers.entries) {
        if (e.key.toLowerCase() == 'authorization') continue;
        b.writeln('║   hdr ${e.key}: ${e.value}');
      }
    }
    if (body != null && body.isNotEmpty) {
      b.writeln('║   body:');
      for (final line in _prettyBody(body).split('\n')) {
        b.writeln('║     $line');
      }
    }
    b.write('╚════════════════════════════════════════════');
    _emit(b.toString(), isError: false);
  }

  static void response({
    required String method,
    required Uri uri,
    required int statusCode,
    required String body,
    Duration? elapsed,
    bool compact = false,
    String? operation,
  }) {
    if (compact) {
      final ms = elapsed == null ? '' : ' ${elapsed.inMilliseconds}ms';
      final snippet = _oneLineSummary(body);
      _emit(
        '║ ◀ $method ${_fullPath(uri)} → $statusCode$ms · $snippet',
        isError: false,
      );
      return;
    }

    final ok = statusCode >= 200 && statusCode < 300;
    final mark = ok ? '✓' : '✗';
    final ms = elapsed == null ? '' : ' (${elapsed.inMilliseconds}ms)';

    final b = StringBuffer()
      ..writeln('╔══ $_label ══ RESPONSE $mark ═══════════════════');
    if (operation != null && operation.isNotEmpty) {
      b.writeln('║   op: $operation');
    }
    b
      ..writeln('║ ◀ $method ${_fullPath(uri)}')
      ..writeln('║   status: $statusCode$ms');
    if (body.isNotEmpty) {
      b.writeln('║   body:');
      for (final line in _prettyBody(body).split('\n')) {
        b.writeln('║     $line');
      }
    } else {
      b.writeln('║   body: (empty)');
    }
    b.write('╚════════════════════════════════════════════');
    _emit(b.toString(), isError: !ok);
  }

  static void _emit(String message, {required bool isError}) {
    try {
      if (isError) {
        talker.error(message);
      } else {
        talker.info(message);
      }
    } catch (_) {
      developer.log(message, name: _label, level: isError ? 1000 : 800);
    }
  }

  static String _fullPath(Uri uri) {
    if (uri.hasQuery) return '${uri.path}?${uri.query}';
    return uri.path;
  }

  static String _prettyBody(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    try {
      final decoded = jsonDecode(trimmed);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return _truncate(trimmed, 4000);
    }
  }

  static String _oneLineSummary(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '(empty)';
    try {
      final map = jsonDecode(trimmed);
      if (map is Map) {
        final parts = <String>[];
        for (final key in ['status', 'jobId', 'operation', 'resultCd', 'error']) {
          if (map.containsKey(key)) {
            parts.add('$key=${map[key]}');
          }
        }
        if (parts.isNotEmpty) return parts.join(' ');
      }
    } catch (_) {}
    return _truncate(trimmed.replaceAll(RegExp(r'\s+'), ' '), 120);
  }

  static String _truncate(String s, int max) {
    if (s.length <= max) return s;
    return '${s.substring(0, max)}… [${s.length - max} more chars]';
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flipper_localize/flipper_localize.dart';

import '../claude/claude_cli_runner.dart';
import '../claude/claude_cli_status.dart';
import '../models/flo_models.dart';
import 'flo_sales_context.dart';

/// Flo chat answered by the user's own Claude subscription through their
/// locally installed Claude Code CLI (desktop only).
///
/// Emits the same `thinking` / `blocks` / `meta` events as [FloChatService] and
/// [LocalFloService], so [AiScreen] consumes it unchanged. Like the on-device
/// path it answers from the device sales snapshot and does not consume Flipper
/// AI credits, because the user is paying Anthropic directly.
class ClaudeFloService {
  const ClaudeFloService();

  static const String _systemPreamble =
      'You are Flo, a concise assistant for a small shop owner. '
      'Answer in plain language, using markdown only when it helps. '
      'Ground every figure in the shop data provided with the question, which '
      'covers the period stated with it. Never invent product names, '
      'quantities or amounts; if the data does not contain what was asked, say '
      'so. You have no tools and cannot browse or run anything.';

  Stream<FloChatEvent> streamChat({
    required String message,
    List<Map<String, String>> history = const [],
    Map<String, dynamic>? deviceSales,
    String? shopName,
    String? currency,
  }) async* {
    final l10n = FlipperL10n.current;

    final status = await ClaudeCli.status(refresh: true);
    switch (status.state) {
      case ClaudeCliState.ready:
        break;
      case ClaudeCliState.notLoggedIn:
        yield FloChatEvent(event: 'error', data: l10n.aiClaudeNotLoggedIn);
        return;
      case ClaudeCliState.notInstalled:
      case ClaudeCliState.unavailable:
        yield FloChatEvent(event: 'error', data: l10n.aiClaudeNotInstalled);
        return;
    }

    yield FloChatEvent(event: 'thinking', data: l10n.aiLocalReadingShopData);
    final prompt = buildPrompt(
      message: message,
      history: history,
      deviceSales: deviceSales,
      shopName: shopName,
      currency: currency,
    );

    yield FloChatEvent(event: 'thinking', data: l10n.aiClaudeThinking);
    final String text;
    try {
      text = await ClaudeCli.runner.ask(
        executable: status.executable!,
        systemPrompt: _systemPreamble,
        prompt: prompt,
      );
    } on ClaudeCliException catch (e) {
      yield FloChatEvent(
        event: 'error',
        data: l10n.aiClaudeFailed(e.message),
      );
      return;
    }

    yield FloChatEvent(
      event: 'blocks',
      data: jsonEncode([
        {'type': 'text', 'html': text.isEmpty ? l10n.aiNoResponse : text},
      ]),
    );
    yield FloChatEvent(
      event: 'meta',
      data: jsonEncode({'model_used': 'claude-cli', 'thinking': const []}),
    );
  }

  static String buildPrompt({
    required String message,
    required List<Map<String, String>> history,
    Map<String, dynamic>? deviceSales,
    String? shopName,
    String? currency,
  }) {
    final cur = currency?.trim() ?? '';
    final b = StringBuffer()
      ..writeln(
        'Shop: ${shopName?.trim().isNotEmpty == true ? shopName : 'your shop'}',
      );
    if (cur.isNotEmpty) {
      b.writeln('Currency is $cur; write money amounts as "$cur <number>".');
    }
    if (deviceSales != null && deviceSales.isNotEmpty) {
      writeDeviceSalesContext(b, deviceSales, cur);
    }
    final turns = history.where((t) => (t['content'] ?? '').trim().isNotEmpty);
    if (turns.isNotEmpty) {
      b
        ..writeln()
        ..writeln('Recent conversation:');
      for (final t in turns) {
        final role = t['role'] == 'assistant' ? 'Assistant' : 'User';
        b.writeln('$role: ${t['content']!.trim()}');
      }
    }
    b
      ..writeln()
      ..write('User question: $message');
    return b.toString();
  }
}

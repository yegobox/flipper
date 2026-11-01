import 'dart:async';
import 'dart:convert';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/local_inference_engine.dart';

import '../local/local_ai_config.dart';
import '../models/flo_models.dart';
import 'flo_sales_context.dart';

/// On-device Flo chat. Mirrors [FloChatService.streamChat]'s event shape
/// (`thinking` / `blocks` / `meta`) so [AiScreen] consumes it with the same
/// parser and renders the same block types.
///
/// Lightweight tier: answers general questions and basic sales questions
/// grounded by the on-device sales snapshot (and, in Phase 2, RAG-retrieved
/// rows). Rich visualization blocks remain cloud-only.
class LocalFloService {
  const LocalFloService();

  static const String _systemPreamble =
      'You are Flo, a concise on-device assistant for a small shop. '
      'Answer briefly and helpfully in plain language. '
      'Use ONLY the figures and items listed in the data below, which is for '
      'the period stated with it. Never invent product names, quantities, or '
      'amounts, and never guess. If the data does not contain what was asked, '
      'say you do not have that information on-device.';

  Stream<FloChatEvent> streamChat({
    required String branchId,
    required String message,
    List<Map<String, String>> history = const [],
    Map<String, dynamic>? deviceSales,
    String? shopName,

    /// ISO/short currency code for the shop (e.g. "RWF"). Injected into the
    /// prompt so the model formats amounts in the right currency instead of
    /// defaulting to "$".
    String? currency,

    /// Optional RAG context (Phase 2): compact rows retrieved from the
    /// on-device Qdrant store, injected verbatim into the prompt.
    String? ragContext,
  }) async* {
    final engine = LocalInferenceRegistry.engine;
    if (engine == null || !engine.isSupported) {
      yield FloChatEvent(
        event: 'error',
        data: FlipperL10n.current.aiLocalUnavailable,
      );
      return;
    }

    // Make first-run weight download visible as a thinking step.
    if (!engine.isReady) {
      yield FloChatEvent(
        event: 'thinking',
        data: FlipperL10n.current.aiLocalPreparing,
      );
      try {
        await engine.ensureModelReady();
      } catch (e) {
        yield FloChatEvent(
          event: 'error',
          data: FlipperL10n.current.aiLocalLoadFailed('$e'),
        );
        return;
      }
    }

    yield FloChatEvent(
        event: 'thinking', data: FlipperL10n.current.aiLocalReadingShopData);

    // On-device retrieval over indexed sales (skipped if a context was passed
    // in, or if retrieval fails / returns nothing).
    var rag = ragContext;
    if (rag == null && engine.supportsRag) {
      try {
        final hits =
            await engine.retrieve(message, topK: LocalAiConfig.ragTopK);
        if (hits.isNotEmpty) {
          rag = hits.map((h) => '- ${h.content}').join('\n');
        }
      } catch (_) {
        // Retrieval is best-effort; fall back to the device snapshot only.
      }
    }

    final prompt = _buildPrompt(
      message: message,
      history: history,
      deviceSales: deviceSales,
      shopName: shopName,
      currency: currency,
      ragContext: rag,
    );

    yield FloChatEvent(
        event: 'thinking', data: FlipperL10n.current.aiLocalThinking);

    final buffer = StringBuffer();
    try {
      await for (final chunk in engine.generate(prompt)) {
        buffer.write(chunk);
      }
    } catch (e) {
      yield FloChatEvent(
          event: 'error',
          data: FlipperL10n.current.aiLocalGenerationFailed('$e'));
      return;
    }

    final text = buffer.toString().trim();
    final blocks = <Map<String, dynamic>>[
      {
        'type': 'text',
        'html': text.isEmpty
            ? 'I could not generate a response on-device. Try switching to a '
                'cloud model for this question.'
            : text,
      },
    ];

    yield FloChatEvent(event: 'blocks', data: jsonEncode(blocks));
    yield FloChatEvent(
      event: 'meta',
      data: jsonEncode({'model_used': 'on-device', 'thinking': const []}),
    );
  }

  String _buildPrompt({
    required String message,
    required List<Map<String, String>> history,
    Map<String, dynamic>? deviceSales,
    String? shopName,
    String? currency,
    String? ragContext,
  }) {
    final cur = currency?.trim() ?? '';
    final b = StringBuffer()
      ..writeln(_systemPreamble)
      ..writeln(
          'Shop: ${shopName?.trim().isNotEmpty == true ? shopName : 'your shop'}');
    if (cur.isNotEmpty) {
      b.writeln(
        'Currency is $cur. Write every money amount as "$cur" followed by the '
        'actual number taken from the data (for example $cur 2500). Never use '
        '"\$", "USD", another currency symbol, or any placeholder text — always '
        'state the real figure.',
      );
    }

    if (ragContext != null && ragContext.trim().isNotEmpty) {
      b
        ..writeln()
        ..writeln('Relevant sales records:')
        ..writeln(ragContext.trim());
    }

    if (deviceSales != null && deviceSales.isNotEmpty) {
      writeDeviceSalesContext(b, deviceSales, cur);
    }

    if (history.isNotEmpty) {
      b
        ..writeln()
        ..writeln('Recent conversation:');
      for (final turn in history) {
        final role = turn['role'] == 'assistant' ? 'Assistant' : 'User';
        final content = (turn['content'] ?? '').trim();
        if (content.isEmpty) continue;
        b.writeln('$role: $content');
      }
    }

    b
      ..writeln()
      ..writeln('User question: $message')
      ..write('Answer:');
    return b.toString();
  }
}

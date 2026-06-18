import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/providers/local_inference_engine.dart';

import '../local/local_ai_config.dart';
import '../models/flo_models.dart';

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
      'If you do not have enough data, say so plainly rather than guessing.';

  Stream<FloChatEvent> streamChat({
    required String branchId,
    required String message,
    List<Map<String, String>> history = const [],
    Map<String, dynamic>? deviceSales,
    String? shopName,
    /// Optional RAG context (Phase 2): compact rows retrieved from the
    /// on-device Qdrant store, injected verbatim into the prompt.
    String? ragContext,
  }) async* {
    final engine = LocalInferenceRegistry.engine;
    if (engine == null || !engine.isSupported) {
      yield const FloChatEvent(
        event: 'error',
        data: 'On-device AI is not available on this device.',
      );
      return;
    }

    // Make first-run weight download visible as a thinking step.
    if (!engine.isReady) {
      yield const FloChatEvent(
        event: 'thinking',
        data: 'Preparing the on-device model…',
      );
      try {
        await engine.ensureModelReady();
      } catch (e) {
        yield FloChatEvent(
          event: 'error',
          data: 'Could not load the on-device model: $e',
        );
        return;
      }
    }

    yield const FloChatEvent(event: 'thinking', data: 'Reading your shop data…');

    // On-device retrieval over indexed sales (skipped if a context was passed
    // in, or if retrieval fails / returns nothing).
    var rag = ragContext;
    if (rag == null && engine.supportsRag) {
      try {
        final hits = await engine.retrieve(message, topK: LocalAiConfig.ragTopK);
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
      ragContext: rag,
    );

    yield const FloChatEvent(event: 'thinking', data: 'Thinking on-device…');

    final buffer = StringBuffer();
    try {
      await for (final chunk in engine.generate(prompt)) {
        buffer.write(chunk);
      }
    } catch (e) {
      yield FloChatEvent(event: 'error', data: 'On-device generation failed: $e');
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
    String? ragContext,
  }) {
    final b = StringBuffer()
      ..writeln(_systemPreamble)
      ..writeln('Shop: ${shopName?.trim().isNotEmpty == true ? shopName : 'your shop'}');

    if (ragContext != null && ragContext.trim().isNotEmpty) {
      b
        ..writeln()
        ..writeln('Relevant sales records:')
        ..writeln(ragContext.trim());
    }

    if (deviceSales != null && deviceSales.isNotEmpty) {
      b
        ..writeln()
        ..writeln("Today's sales snapshot (from this device):")
        ..writeln(jsonEncode(deviceSales));
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

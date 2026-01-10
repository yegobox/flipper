import 'package:flipper_models/providers/ai_provider.dart';

/// Unified input structure for both Gemini and OpenAI/Groq
class UnifiedAIInput {
  final List<Content> contents;
  final GenerationConfig? generationConfig;
  final String? model;

  UnifiedAIInput({
    required this.contents,
    this.generationConfig,
    this.model,
  });

  /// Convert to Gemini-compatible JSON
  Map<String, dynamic> toGeminiJson() => {
        'contents': contents.map((e) => e.toJson()).toList(),
        if (generationConfig != null)
          'generationConfig': generationConfig!.toJson(),
      };

  /// Convert to OpenAI/Groq-compatible JSON
  Map<String, dynamic> toOpenAIJson() {
    final messages = contents.map((content) {
      final role =
          content.role == 'model' ? 'assistant' : (content.role ?? 'user');

      // OpenAI expects a simple string content for text-only messages
      // or an array of content parts for multimodal/complex messages.
      // For simplicity, we'll join text parts.
      final textContent = content.parts
          .where((p) => p.text != null)
          .map((p) => p.text)
          .join('\n');

      return {
        'role': role,
        'content': textContent,
      };
    }).toList();

    return {
      'model': model,
      'messages': messages,
      if (generationConfig?.temperature != null)
        'temperature': generationConfig!.temperature,
      if (generationConfig?.maxOutputTokens != null)
        'max_completion_tokens': generationConfig!
            .maxOutputTokens, // OpenAI uses max_completion_tokens (new) or max_tokens
    };
  }
}

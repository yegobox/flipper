import 'package:flipper_models/providers/ai_provider.dart';

/// Unified input structure for both Gemini and OpenAI/Groq
class UnifiedAIInput {
  final List<Content> contents;
  final GenerationConfig? generationConfig;
  final String? model;

  UnifiedAIInput({required this.contents, this.generationConfig, this.model});

  /// Convert to Gemini-compatible JSON
  Map<String, dynamic> toGeminiJson() => {
    'contents': contents.map((e) => e.toJson()).toList(),
    if (generationConfig != null)
      'generationConfig': generationConfig!.toJson(),
  };

  /// Convert to OpenAI/Groq-compatible JSON
  Map<String, dynamic> toOpenAIJson() {
    final messages = contents.map((content) {
      final role = content.role == 'model'
          ? 'assistant'
          : (content.role ?? 'user');

      // OpenAI expects a simple string content for text-only messages
      // or an array of content parts for multimodal/complex messages.
      // For simplicity, we'll join text parts.
      final textContent = content.parts
          .where((p) => p.text != null)
          .map((p) => p.text)
          .join('\n');

      return {'role': role, 'content': textContent};
    }).toList();

    return {
      'model': model,
      'messages': messages,
      if (generationConfig?.temperature != null)
        'temperature': generationConfig!.temperature,
      if (generationConfig?.maxOutputTokens != null) ...{
        'max_completion_tokens': generationConfig!.maxOutputTokens,
        'max_tokens': generationConfig!.maxOutputTokens,
      },
    };
  }

  /// Flatten the conversation into a single role-tagged prompt string for
  /// on-device engines that take plain text rather than a structured request.
  /// Non-text parts (e.g. inline image data) are skipped — local models in
  /// this tier are text-only.
  String toPlainPrompt() {
    final buffer = StringBuffer();
    for (final content in contents) {
      final role = content.role == 'model'
          ? 'Assistant'
          : (content.role == null
              ? 'User'
              : '${content.role![0].toUpperCase()}${content.role!.substring(1)}');
      final text = content.parts
          .where((p) => p.text != null && p.text!.trim().isNotEmpty)
          .map((p) => p.text!.trim())
          .join('\n');
      if (text.isEmpty) continue;
      buffer.writeln('$role: $text');
    }
    return buffer.toString().trim();
  }
}

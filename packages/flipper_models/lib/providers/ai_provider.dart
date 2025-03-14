import 'dart:convert';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_provider.g.dart';

/// Define the input data structure
class GeminiInput {
  final List<Content> contents;
  final Map<String, dynamic>? safetySettings;
  final GenerationConfig? generationConfig;

  GeminiInput({
    required this.contents,
    this.safetySettings,
    this.generationConfig,
  });

  Map<String, dynamic> toJson() => {
        'contents': contents.map((e) => e.toJson()).toList(),
        if (safetySettings != null) 'safetySettings': safetySettings,
        if (generationConfig != null) 'generationConfig': generationConfig,
      };
}

/// Generation configuration
class GenerationConfig {
  final double? temperature;
  final int? maxOutputTokens;

  GenerationConfig({
    this.temperature,
    this.maxOutputTokens,
  });

  Map<String, dynamic> toJson() => {
        if (temperature != null) 'temperature': temperature,
        if (maxOutputTokens != null) 'maxOutputTokens': maxOutputTokens,
      };
}

/// Content structure
class Content {
  final List<Part> parts;
  final String? role;

  Content({required this.parts, this.role});

  Map<String, dynamic> toJson() => {
        'parts': parts.map((e) => e.toJson()).toList(),
        if (role != null) 'role': role,
      };
}

/// Part of the content
class Part {
  final String text;

  Part({required this.text});

  Map<String, dynamic> toJson() => {
        'text': text,
      };
}

/// Providers
@riverpod
class GeminiResponse extends _$GeminiResponse {
  @override
  Future<String> build(GeminiInput input) async {
    final url = Uri.parse(AppSecrets.googleAiUrl + AppSecrets.googleKey);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(input.toJson()),
      );

      if (response.statusCode == 200) {
        final decodedResponse =
            jsonDecode(response.body) as Map<String, dynamic>;
        final content = decodedResponse['candidates'][0]['content'];
        final parts = content['parts'] as List<dynamic>;
        final text = parts.map((e) => e['text'] as String).join('\n');
        return text;
      } else {
        throw Exception(
            'Failed to fetch data from Gemini API: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error calling Gemini API: $e');
    }
  }
}

@riverpod
class GeminiBusinessAnalytics extends _$GeminiBusinessAnalytics {
  @override
  Future<String> build(int branchId, String userPrompt) async {
    final businessAnalyticsData =
        await ProxyService.strategy.analytics(branchId: branchId);

    String csvData =
        "Date,Item Name,Price,Profit,Units Sold,Tax Rate,Traffic Count\n" +
            businessAnalyticsData.map((e) => e.toString()).join('\n');

    // Enhanced prompt for accounting-focused formatting
    final basePrompt = """
Format the response following these accounting guidelines:
1. Numbers should be formatted with 2 decimal places (e.g., 1234.56)
2. Percentages should be clearly marked with % symbol
3. Dates should be in DD/MM/YYYY format
4. Currency values should be prefixed with currency symbol
5. For calculations:
   - Show subtotals clearly
   - Separate line items with clear breaks
   - Show formulas used if relevant
6. Group related items together under headers
7. If showing comparisons:
   - Use clear "Previous vs Current" format
   - Show percentage changes
8. Round large numbers appropriately (e.g., "1.2M" for millions)

$userPrompt
""";

    final inputData = GeminiInput(
      contents: [
        Content(
          parts: [
            Part(text: csvData),
            Part(text: basePrompt),
            Part(text: """
Please structure the response in this format:
[SUMMARY]
Brief overview of key figures

[DETAILS]
Detailed breakdown with proper formatting

[CALCULATIONS]
Any relevant calculations with formulas shown

Note: Keep responses concise and numbers exact. Remove any explanatory text unless specifically requested.
"""),
          ],
        ),
      ],
      generationConfig: GenerationConfig(
        temperature: 0.3, // Lower temperature for more consistent formatting
        maxOutputTokens: 2048,
      ),
    );

    return await ref.watch(geminiResponseProvider(inputData).future);
  }
}

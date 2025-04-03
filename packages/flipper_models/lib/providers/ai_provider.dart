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

    // Get current time for temporal context
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Format CSV with all available fields
    String csvData =
        "ID,Date,Value,Branch ID,Item Name,Price,Profit,Units Sold,Tax Rate,Traffic Count\n" +
            businessAnalyticsData.map((e) => e.toString()).join('\n');

    // Enhanced prompt with temporal context
    final basePrompt = """
Current Time Context:
- Current Date: ${today.toString().split(' ')[0]}
- Today refers to: ${today.toString().split(' ')[0]}
- This week refers to: dates from ${today.subtract(Duration(days: today.weekday - 1)).toString().split(' ')[0]} to ${today.toString().split(' ')[0]}
- This month refers to: dates in ${today.month}/${today.year}

Analyze the provided business data following these guidelines:
1. Time-Based Analysis:
   - When user mentions "today", analyze data for ${today.toString().split(' ')[0]}
   - For "this week", analyze data from this week's Monday to today
   - For "this month", analyze all data from current month
   - For "yesterday", analyze data from ${today.subtract(const Duration(days: 1)).toString().split(' ')[0]}
   - Default to all-time analysis if no time period is specified

2. Financial Formatting:
   - Currency: Format with 2 decimals and RWF symbol (e.g., RWF 1,234.56)
   - Percentages: Include % symbol (e.g., 18%)
   - Dates: Use DD/MM/YYYY format
   - Large numbers: Use comma separators (e.g., 1,234)

3. Analysis Requirements:
   - Sales Analysis: Total revenue, average price, total profit
   - Product Performance: Best/worst selling items by units and revenue
   - Tax Impact: Calculate total tax amount (value × tax_rate)
   - Traffic Analysis: Average sales per customer (units_sold/traffic_count)

4. Data Grouping:
   - Group items by product category when possible
   - Show time-based trends if multiple dates exist
   - Compare performance metrics across products

5. Response Formatting:
   - For tax calculations: Present a clear summary at the top, followed by detailed breakdown
   - Use concise tables with proper alignment and clear headers
   - Include a visual separator between summary and details sections
   - For tax queries: Group identical items and show consolidated totals
   - Exclude zero-value entries from calculations and tables
   - End with a clearly highlighted total in bold

User Query: $userPrompt
""";

    // If there's no analytics data, provide a fallback response
    if (businessAnalyticsData.isEmpty) {
      return "I don't have enough data to analyze at the moment. Please make sure you have some sales or inventory data in your system.";
    }

    final inputData = GeminiInput(
      contents: [
        Content(
          role: "user",
          parts: [
            Part(text: csvData),
            Part(text: basePrompt),
          ],
        ),
      ],
      generationConfig: GenerationConfig(
        temperature:
            0.2, // Lower temperature for more precise numerical analysis
        maxOutputTokens: 2048,
      ),
    );

    try {
      return await ref.read(geminiResponseProvider(inputData).future);
    } catch (e) {
      // Provide a fallback response if the API call fails
      return "I'm having trouble analyzing your data right now. Please try again in a moment. Error: ${e.toString().split('Exception:').last}";
    }
  }
}

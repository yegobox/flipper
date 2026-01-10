import 'dart:convert';
import 'dart:io'; // Import for File
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/business_analytic.model.dart';
import 'package:supabase_models/brick/models/credit.model.dart';
import 'package:mime/mime.dart'; // Import for lookupMimeType
import 'package:flipper_models/utils/excel_utility.dart';

import 'package:flipper_models/providers/unified_ai_input.dart';
import 'package:flipper_models/models/ai_model.dart';
import 'package:flipper_models/repositories/ai_model_repository.dart';

part 'ai_provider.g.dart';

@riverpod
Future<List<AIModel>> availableModels(Ref ref) async {
  final repository = AIModelRepository();
  return await repository.getAvailableModels();
}

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
        if (generationConfig != null)
          'generationConfig': generationConfig!.toJson(),
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
  final String? text; // Changed _text to text to be public
  final Map<String, dynamic>? _inlineData;

  // Private constructor
  Part._({this.text, Map<String, dynamic>? inlineData})
      : _inlineData = inlineData,
        assert(
            (text != null && inlineData == null) ||
                (text == null && inlineData != null),
            'A Part must contain either text or inline_data, but not both, and not neither.');

  // Factory constructor for text parts
  factory Part.text(String text) => Part._(text: text);

  // Factory constructor for inline data parts
  factory Part.inlineData(String mimeType, String data) =>
      Part._(inlineData: {'mime_type': mimeType, 'data': data});

  Map<String, dynamic> toJson() {
    if (text != null) {
      return {'text': text};
    } else if (_inlineData != null) {
      return {'inline_data': _inlineData!};
    }
    // This case should ideally not be reached due to the assert
    throw StateError(
        'Invalid Part state: neither text nor inline_data is present.');
  }
}

/// Converts a file to a base64 encoded string with its MIME type.
Future<Map<String, dynamic>> fileToBase64(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) {
    throw Exception('File not found: $filePath');
  }

  final bytes = await file.readAsBytes();
  final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

  return {
    "mime_type": mimeType,
    "data": base64Encode(bytes),
  };
}

/// Providers
@riverpod
class GeminiResponse extends _$GeminiResponse {
  @override
  Future<String> build(UnifiedAIInput input, AIModel? aiModel) async {
    // Determine configuration
    final isGemini = aiModel?.isGeminiStandard ?? true;
    final apiUrl = aiModel?.apiUrl ?? AppSecrets.googleAiUrl;
    final apiKey = aiModel?.apiKey ?? AppSecrets.googleKey;

    // USAGE TRACKING & ACCESS CONTROL
    // -------------------------------
    // 1. Get current business
    final business =
        await ProxyService.getStrategy(Strategy.capella).activeBusiness();

    if (business != null) {
      talker.info(
          'AI Provider: Checking constraints for business ${business.id}');
      final repository = AIModelRepository();

      // 2. Check "Paid Only" Restriction
      if (aiModel?.isPaidOnly == true) {
        final isPro = business.subscriptionPlan == 'pro' ||
            business.subscriptionPlan == 'enterprise';

        if (!isPro) {
          // Check for credits if not Pro
          final branchId = ProxyService.box.getBranchId();
          bool hasCredits = false;

          if (branchId != null) {
            final creditRecord =
                await ProxyService.getStrategy(Strategy.capella)
                    .getCredit(branchId: branchId);

            // Assuming 1 credit per request cost for now
            if (creditRecord != null && creditRecord.credits >= 1) {
              hasCredits = true;

              // Deduct 1 credit
              final updatedCredits = creditRecord.credits - 1;
              final updatedCreditRecord = Credit(
                id: creditRecord.id,
                branchId: creditRecord.branchId,
                businessId: creditRecord.businessId,
                credits: updatedCredits,
                createdAt: creditRecord.createdAt,
                updatedAt: DateTime.now(),
                branchServerId: creditRecord.branchServerId,
              );

              await ProxyService.getStrategy(Strategy.capella)
                  .updateCredit(updatedCreditRecord);

              talker.info(
                  'Deducted 1 credit for AI usage. Remaining: $updatedCredits');
            }
          }

          if (!hasCredits) {
            throw Exception(
                'Upgrade Required: The selected model (${aiModel?.name}) is available on Pro plans only or requires credits.');
          }
        }
      }

      // 3. Check Usage Limits
      final config = await repository.getBusinessConfig(business.id);
      if (config != null) {
        if (config.isQuotaExceeded) {
          throw Exception(
              'Usage Limit Reached: You have used ${config.currentUsage}/${config.usageLimit} requests. Please upgrade your plan.');
        }
      } else {
        // If config is still null after repository attempts to create it, something is wrong.
        // We can block or allow with warning. Choosing to allow for now but log error.
        talker.error(
            'AI Provider: Failed to retrieve or create usage config for business ${business.id}');
      }
    }

    // Validate model ID for non-Gemini APIs
    if (!isGemini && (aiModel?.modelId == null || aiModel!.modelId.isEmpty)) {
      throw Exception(
          'Model ID is required for ${aiModel?.provider ?? "this API provider"}. Please ensure the AI model configuration includes a valid model_id.');
    }

    // Construct URL and Headers
    Uri url;
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body;

    if (isGemini) {
      // Gemini Standard: Key in URL
      url = Uri.parse('$apiUrl$apiKey');
      body = jsonEncode(input.toGeminiJson());
      talker.info('AI Request (Gemini Standard): $url');
    } else {
      // OpenAI/Groq Standard: Key in Header
      url = Uri.parse(apiUrl);
      headers['Authorization'] = 'Bearer $apiKey';
      body = jsonEncode(input.toOpenAIJson());
      talker.info('AI Request (OpenAI Standard): $url');
    }

    // talker.info('Request Body: $body');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        talker.info('AI API response body: ${response.body}');
        final decodedResponse =
            jsonDecode(response.body) as Map<String, dynamic>;

        if (isGemini) {
          // Parse Gemini Response
          final candidates = decodedResponse['candidates'] as List<dynamic>?;
          if (candidates == null || candidates.isEmpty) {
            throw Exception('No response candidates from Gemini API');
          }
          final content = candidates[0]['content'];
          if (content == null || content['parts'] == null) {
            throw Exception('Invalid content structure in Gemini API response');
          }
          final parts = content['parts'] as List<dynamic>;

          // For successful responses, return the data even if the provider is no longer mounted
          // since we've already successfully obtained the result from the API
          return parts.map((e) => e['text'] as String).join('\n');
        } else {
          // Parse OpenAI/Groq Response
          final choices = decodedResponse['choices'] as List<dynamic>?;
          if (choices == null || choices.isEmpty) {
            throw Exception('No choices from AI API');
          }
          final message = choices[0]['message'];
          final content = message['content'] as String?;

          if (content == null) {
            throw Exception('No content in AI API response');
          }

          // For successful responses, return the data even if the provider is no longer mounted
          // since we've already successfully obtained the result from the API
          return content;
        }
      } else {
        // For error responses, we should still check if mounted before throwing
        if (!ref.mounted) throw Exception('Provider disposed');
        talker.error('AI API Error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to fetch data from AI API: ${response.statusCode}, ${response.body}');
      }
    } catch (e, stack) {
      if (e.toString().contains('Provider disposed')) {
        rethrow;
      }
      talker.error('Error calling AI API: $e');
      talker.error(stack);
      rethrow;
    }
  }
}

@riverpod
class GeminiBusinessAnalytics extends _$GeminiBusinessAnalytics {
  @override
  Future<String> build(String branchId, String userPrompt,
      {String? filePath, List<Content>? history, AIModel? aiModel}) async {
    final businessAnalyticsData =
        await ProxyService.getStrategy(Strategy.capella)
            .analytics(branchId: branchId);

    // Check if the user wants to buy credits
    final lowerCasePrompt = userPrompt.toLowerCase();
    if (lowerCasePrompt.contains('buy credit') ||
        lowerCasePrompt.contains('purchase credit') ||
        lowerCasePrompt.contains('add credit') ||
        lowerCasePrompt.contains('get credit') ||
        lowerCasePrompt.contains('top up')) {
      // Check if the user provided phone number and credit amount
      if (userPrompt.contains('#') && RegExp(r'\d+').hasMatch(userPrompt)) {
        // Extract phone number and credit amount from the command
        // Expected format: "buy credit 100 #2507XXXXXXXX" or similar
        final phoneMatch = RegExp(r'#(\d+)').firstMatch(userPrompt);
        final creditMatch =
            RegExp(r'(\d+)').firstMatch(userPrompt.split(RegExp(r'#\d+'))[0]);

        if (phoneMatch != null) {
          final phoneNumber = phoneMatch.group(1);
          final creditAmount =
              creditMatch != null ? int.tryParse(creditMatch.group(1)!) : null;

          if (creditAmount != null && creditAmount > 0) {
            // Attempt to purchase credits using the membership API
            try {
              // Get the current business to determine the branch
              final business = await ProxyService.getStrategy(Strategy.capella)
                  .activeBusiness();
              if (business == null) {
                return "Credit Purchase Failed: No active business found. Please ensure you're logged in and have an active business.";
              }

              // Get or create the credit record for the branch
              var creditRecord =
                  await ProxyService.getStrategy(Strategy.capella)
                      .getCredit(branchId: branchId);
              if (creditRecord == null) {
                // Create a new credit record if it doesn't exist
                creditRecord = Credit(
                  branchId: branchId,
                  businessId: business.id,
                  credits: 0.0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  branchServerId:
                      branchId, // Using branchId as branchServerId for simplicity
                );
              }

              // Update the credit amount
              final updatedCredits =
                  creditRecord.credits + creditAmount.toDouble();
              final updatedCreditRecord = Credit(
                id: creditRecord.id,
                branchId: creditRecord.branchId,
                businessId: creditRecord.businessId,
                credits: updatedCredits,
                createdAt: creditRecord.createdAt,
                updatedAt: DateTime.now(),
                branchServerId: creditRecord.branchServerId,
              );

              // Save the updated credit record
              await ProxyService.getStrategy(Strategy.capella)
                  .updateCredit(updatedCreditRecord);

              return "Credit Purchase Successful: $creditAmount credits have been added to account associated with phone number $phoneNumber. Your new credit balance is ${updatedCredits.toInt()} credits.";
            } catch (e) {
              return "Credit Purchase Failed: Unable to process your credit purchase request. Error: ${e.toString()}";
            }
          } else {
            return "Credit Purchase Command Format: To buy credits, use the format 'buy credit [amount] #[phone-number]' or 'purchase [amount] credits for #[phone-number]'. Example: 'buy credit 100 #250712345678'";
          }
        } else {
          return "Credit Purchase Command Format: To buy credits, use the format 'buy credit [amount] #[phone-number]' or 'purchase [amount] credits for #[phone-number]'. Example: 'buy credit 100 #250712345678'";
        }
      } else {
        return "Credit Purchase Command Format: To buy credits, use the format 'buy credit [amount] #[phone-number]' or 'purchase [amount] credits for #[phone-number]'. Example: 'buy credit 100 #250712345678'";
      }
    }

    if (!ref.mounted) return "Operation cancelled";

    String enrichedUserPrompt = userPrompt;

    // Handle Excel file parsing within the provider for smaller provider keys and better stability.
    if (filePath != null &&
        (filePath.endsWith('.xlsx') || filePath.endsWith('.xls'))) {
      talker.info('Parsing Excel data in AI provider: $filePath');
      try {
        final excelMarkdown = await ExcelUtility.excelToMarkdown(filePath);
        enrichedUserPrompt =
            "$enrichedUserPrompt\n\nAttached Excel Data:\n$excelMarkdown";
      } catch (e) {
        talker.error('Excel parsing failed in provider: $e');
      }
    }

    // Get current time for temporal context
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Enhanced prompt with temporal context
    final String basePrompt = """
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

6. Visualization Data:
   - If your response includes data that should be visualized (like tax information, business analytics, etc.), 
     include a structured JSON block in the following format:

   {{VISUALIZATION_DATA}}
   {
     "type": "tax|business_analytics|inventory",
     // For tax visualization include:
     "title": "Tax Summary",
     "date": "DD/MM/YYYY",
     "totalTax": 1234.56,
     "currencyCode": "RWF",
     "items": [
       {"name": "Product Name", "taxAmount": 123.45},
       // Add more items as needed
     ]
          // For business_analytics visualization include:
      "revenue": 1234.56,
      "profit": 567.89,
      "unitsSold": 42,
      "currencyCode": "RWF",
      
      // For financial_report visualization include (Multi-series line chart):
      "type": "financial_report",
      "title": "Monthly Performance",
      "xAxisLabel": "Month",
      "yAxisLabel": "Amount (RWF)",
      "labels": ["Jan", "Feb", "Mar"], // Months or time periods
      "datasets": [
        {
          "label": "Revenue",
          "data": [4500000, 4800000, 5200000],
          "color": "#0078D4"
        },
        {
          "label": "Net Profit",
          "data": [900000, 950000, 1200000],
          "color": "#107C10"
        }
      ]
      
      // For inventory visualization include appropriate fields
   }
   {{/VISUALIZATION_DATA}}

User Query: $enrichedUserPrompt
""";

    // Format CSV with all available fields
    String csvData =
        "ID,Date,Value,Branch ID,Item Name,Price,Profit,Units Sold,Tax Rate,Traffic Count\n" +
            businessAnalyticsData.map((e) => e.toString()).join('\n');

    final List<Part> currentTurnParts = [];

    // Always add the user's text prompt
    currentTurnParts.add(Part.text(userPrompt));

    // Add file data if present
    if (filePath != null) {
      final fileData = await fileToBase64(filePath);
      if (!ref.mounted) return "Operation cancelled";
      currentTurnParts
          .add(Part.inlineData(fileData['mime_type'], fileData['data']));
      currentTurnParts.add(Part.text(
          "The user has attached a file. Please use it as additional context for the analysis."));
    }

    // Always add business data and base prompt for context.
    currentTurnParts.add(Part.text(csvData));
    currentTurnParts.add(Part.text(basePrompt));

    final List<Content> contents = [];
    if (history != null) {
      contents.addAll(history);
    }
    contents.add(Content(role: "user", parts: currentTurnParts));

    if (businessAnalyticsData.isEmpty && filePath == null) {
      return "I don't have enough data to analyze at the moment. Please make sure you have some sales or inventory data in your system.";
    }

    // For now we assume Gemini for Business Analytics unless specialized model logic is added
    // If we want to support Groq here, we'd need to pass an AIModel.
    // For now, let's assume default Gemini configuration (null model acts as default or fallback)

    final inputData = UnifiedAIInput(
      contents: contents,
      model: aiModel?.modelId,
      generationConfig: GenerationConfig(
        temperature: 0.2,
        maxOutputTokens: 2048,
      ),
    );

    try {
      if (!ref.mounted) return "Operation cancelled";
      talker.info('Directing to Gemini provider with enriched prompt...');
      // Pass the selected AIModel (or null which defaults to Gemini in GeminiResponse)
      final result =
          await ref.read(geminiResponseProvider(inputData, aiModel).future);
      // If we get a result from the nested provider, return it even if this provider is no longer mounted
      // since the AI call was successful
      return result;
    } catch (e, stack) {
      if (e.toString().contains('Provider disposed')) {
        return "Operation cancelled";
      }
      talker.error('Exception in GeminiBusinessAnalytics: $e');
      talker.error(stack);

      // Provide more user-friendly error messages for specific cases
      if (e.toString().contains('Upgrade Required')) {
        // Extract the model name from the error message for a more personalized message
        final modelMatch =
            RegExp(r'The selected model \(([^)]+)\)').firstMatch(e.toString());
        final modelName = modelMatch?.group(1) ?? 'this AI model';
        return "To use $modelName, you need either a Pro plan subscription or sufficient credits. You can upgrade your subscription or purchase credits to access this feature.";
      }

      // Provide a fallback response if the API call fails
      return "I'm sorry, I couldn't process your request at the moment. Please try again later.";
    }
  }
}

@riverpod
Future<String> geminiSummary(Ref ref, String prompt) async {
  final inputData = UnifiedAIInput(
    contents: [
      Content(
        role: "user",
        parts: [
          Part.text(prompt),
        ],
      ),
    ],
    model: null, // Will use default Gemini model
    generationConfig: GenerationConfig(
      temperature: 0.7, // Higher temperature for more creative summaries
      maxOutputTokens: 512,
    ),
  );

  try {
    return await ref.read(geminiResponseProvider(inputData, null).future);
  } catch (e) {
    // Handle specific upgrade error
    if (e.toString().contains('Upgrade Required')) {
      // Extract the model name from the error message for a more personalized message
      final modelMatch =
          RegExp(r'The selected model \(([^)]+)\)').firstMatch(e.toString());
      final modelName = modelMatch?.group(1) ?? 'this AI model';
      return "To use $modelName, you need either a Pro plan subscription or sufficient credits. You can upgrade your subscription or purchase credits to access this feature.";
    }
    return "I'm sorry, I couldn't generate a summary at the moment. Please try again later.";
  }
}

@riverpod
Stream<List<BusinessAnalytic>> streamedBusinessAnalytics(
    Ref ref, String branchId) {
  return ProxyService.getStrategy(Strategy.capella)
      .streamRemoteAnalytics(branchId: branchId);
}

import 'dart:convert';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'ai_provider.g.dart';
// query data for knowledge

// Define the input data structure
class GeminiInput {
  final List<Content> contents;

  GeminiInput({required this.contents});

  Map<String, dynamic> toJson() => {
        'contents': contents.map((e) => e.toJson()).toList(),
      };
}

class Content {
  final List<Part> parts;

  Content({required this.parts});

  Map<String, dynamic> toJson() => {
        'parts': parts.map((e) => e.toJson()).toList(),
      };
}

class Part {
  final String text;

  Part({required this.text});

  Map<String, dynamic> toJson() => {
        'text': text,
      };
}

// Create the provider using riverpod annotation
@riverpod
Future<String> geminiResponse(Ref ref, GeminiInput input) async {
  final url = Uri.parse(AppSecrets.googleAiUrl + AppSecrets.googleKey);

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode == 200) {
      //print(response.body); //uncomment to debug the output.

      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

      // Extract the response text.  This assumes a specific structure.  Adjust as needed.
      final content = decodedResponse['candidates'][0]['content'];
      final parts = content['parts'] as List<dynamic>;
      final text = parts.map((e) => e['text'] as String).join('\n');

      return text; // Or return a more complex data structure if needed
    } else {
      throw Exception(
          'Failed to fetch data from Gemini API: ${response.statusCode}, ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling Gemini API: $e');
  }
}

@riverpod
Future<String> geminiBusinessAnalyticsResponse(
    Ref ref, int branchId, String userPrompt) async {
  //Get the list of BusinessAnalytic from the AsyncData
  final businessAnalyticsData =
      await ProxyService.strategy.analytics(branchId: branchId);

  //Create the CSV String data from the list of BusinessAnalytics.
  String csvData =
      "Date,Item Name,Price,Profit,Units Sold,Tax Rate,Traffic Count\n" +
          businessAnalyticsData.map((e) => e.toString()).join('\n');

  //Create the input data using Gemini
  final inputData = GeminiInput(
    contents: [
      Content(
        parts: [
          Part(
            text: csvData,
          ),
          Part(text: userPrompt // Use the user's prompt from the UI
              ),
          Part(
            text:
                "format data into normal sentence/paragraph, remove any explanation from answer",
          ),
          Part(
            text:
                "always be exact if it is a number required only give a number less texts",
          ),
        ],
      ),
    ],
  );
  //return the response from gemini from the call.
  return await ref.watch(geminiResponseProvider(inputData).future);
}

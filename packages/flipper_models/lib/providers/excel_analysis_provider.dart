import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/utils/excel_utility.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flipper_models/models/ai_model.dart';
import 'package:flipper_models/providers/unified_ai_input.dart';

part 'excel_analysis_provider.g.dart';

class ExcelAnalysisState {
  final List<Content> history;
  final bool isLoading;
  final String? error;
  final String? lastVisualizationData;
  final Map<String, Map<String, dynamic>> excelData;
  final String? filePath;
  final List<AIModel> availableModels;

  final AIModel? selectedModel;
  final String? markdownData;

  ExcelAnalysisState({
    this.history = const [],
    this.isLoading = false,
    this.error,
    this.lastVisualizationData,
    this.excelData = const {},
    this.filePath,
    this.availableModels = const [],
    this.selectedModel,
    this.markdownData,
  });

  ExcelAnalysisState copyWith({
    List<Content>? history,
    bool? isLoading,
    String? error,
    String? lastVisualizationData,
    Map<String, Map<String, dynamic>>? excelData,
    String? filePath,
    List<AIModel>? availableModels,
    AIModel? selectedModel,
    String? markdownData,
  }) {
    return ExcelAnalysisState(
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastVisualizationData:
          lastVisualizationData ?? this.lastVisualizationData,
      excelData: excelData ?? this.excelData,
      filePath: filePath ?? this.filePath,
      availableModels: availableModels ?? this.availableModels,
      selectedModel: selectedModel ?? this.selectedModel,
      markdownData: markdownData ?? this.markdownData,
    );
  }
}

@riverpod
class ExcelAnalysis extends _$ExcelAnalysis {
  @override
  ExcelAnalysisState build() {
    return ExcelAnalysisState();
  }

  String _parseFriendlyError(dynamic error) {
    final errorStr = error.toString();

    // Check for quota exceeded
    if (errorStr.contains('429') ||
        errorStr.contains('RESOURCE_EXHAUSTED') ||
        errorStr.contains('quota')) {
      return '⏱️ API Rate Limit Reached\n\nYou\'ve hit the free tier limit for AI requests. Please wait a minute and try again, or upgrade your API plan for unlimited access.';
    }

    // Check for authentication errors
    if (errorStr.contains('401') ||
        errorStr.contains('403') ||
        errorStr.contains('UNAUTHENTICATED')) {
      return '🔐 Authentication Error\n\nYour API key may be invalid or expired. Please check your configuration.';
    }

    // Check for network errors
    if (errorStr.contains('SocketException') ||
        errorStr.contains('Failed host lookup')) {
      return '🌐 Network Error\n\nCouldn\'t connect to the AI service. Please check your internet connection.';
    }

    // Generic error
    return '❌ Analysis Failed\n\nSomething went wrong while analyzing your data. Please try again or contact support if the issue persists.';
  }

  Future<void> initWithFile(
    String filePath, {
    AIModel? preSelectedModel,
  }) async {
    talker.info('ExcelAnalysis: Initializing with file: $filePath');
    state = state.copyWith(isLoading: true, filePath: filePath);
    try {
      final data = await ExcelUtility.excelToData(filePath);
      talker.info('ExcelAnalysis: Extracted ${data.length} sheets');

      final markdown = await ExcelUtility.excelToMarkdown(filePath);
      talker.info(
        'ExcelAnalysis: Generated markdown (${markdown.length} chars)',
      );

      final supabase = Supabase.instance.client;

      // Fetch models directly from Supabase
      final response = await supabase
          .from('ai_models')
          .select()
          .eq('is_active', true)
          .order('is_default', ascending: false)
          .order('name', ascending: true);

      final models = (response as List)
          .map((json) => AIModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final defaultModel = models.firstWhere(
        (m) => m.isDefault,
        orElse: () => models.isNotEmpty
            ? models.first
            : throw Exception('No models available'),
      );

      // Use preSelectedModel if provided, otherwise fallback to default
      final modelToUse = preSelectedModel ?? defaultModel;

      state = state.copyWith(
        excelData: data,
        history: [],
        availableModels: models,
        selectedModel: modelToUse,
        isLoading: false,
        markdownData: markdown,
      );

      // Trigger initial AI response with context
      // We send a clean message to the UI, but the provider will inject the markdown data
      await analyzeMessage(
        "Please analyze this data and provide: 1) A visualization showing key trends or metrics, and 2) A brief summary of the main insights.",
      );
    } catch (e, stack) {
      talker.error('ExcelAnalysis: Init failed: $e');
      talker.error(stack);
      state = state.copyWith(isLoading: false, error: _parseFriendlyError(e));
    }
  }

  Future<void> setModel(AIModel model) async {
    talker.info('ExcelAnalysis: Switching to model: ${model.name}');
    state = state.copyWith(selectedModel: model);
  }

  Future<void> analyzeMessage(String userPrompt) async {
    if (state.isLoading) {
      talker.warning('ExcelAnalysis: Already loading, ignoring message');
      return;
    }

    talker.info('ExcelAnalysis: Analyzing message: $userPrompt');

    final userMessage = Content(role: "user", parts: [Part.text(userPrompt)]);

    final newHistory = [...state.history, userMessage];

    state = state.copyWith(history: newHistory, isLoading: true, error: null);

    try {
      // Prepare contents for AI, injecting markdown data if needed
      List<Content> apiContents = List.from(newHistory);

      // 1. Inject Excel Data into the first message (Context)
      if (state.markdownData != null && apiContents.isNotEmpty) {
        if (apiContents[0].role == 'user') {
          final originalText =
              apiContents[0].parts
                      .firstWhere(
                        (p) => p.toJson().containsKey('text'),
                        orElse: () => Part.text(''),
                      )
                      .toJson()['text']
                  as String;

          final dataContext =
              "Here is the Excel data to analyze:\n\n${state.markdownData}\n\n$originalText";

          apiContents[0] = Content(
            role: "user",
            parts: [Part.text(dataContext)],
          );
        }
      }

      // 2. Inject Visualization Instructions into the LAST message (Immediate Instruction)
      // This ensures the model sees the strict formatting requirements right after the specific user question.
      if (apiContents.isNotEmpty) {
        final lastIdx = apiContents.length - 1;
        if (apiContents[lastIdx].role == 'user') {
          final currentText =
              apiContents[lastIdx].parts
                      .firstWhere(
                        (p) => p.toJson().containsKey('text'),
                        orElse: () => Part.text(''),
                      )
                      .toJson()['text']
                  as String;

          const visualizationInstructions = """

CRITICAL REQUIREMENT: You MUST include a visualization for this financial data.

The "type" field in the JSON MUST be exactly "financial_report". Do NOT use "line_chart" or "bar_chart".

Your response MUST follow this exact structure:
1. First, output the {{VISUALIZATION_DATA}} block with the chart data
2. Then, provide a brief 2-3 sentence summary

Example format:
{{VISUALIZATION_DATA}}
{
  "type": "financial_report",
  "title": "Monthly Financial Performance",
  "xAxisLabel": "Month",
  "yAxisLabel": "Amount (RWF)",
  "labels": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"],
  "datasets": [
    {
      "label": "Revenue",
      "data": [4500000, 4800000, 5200000, 5000000, 5600000, 5900000, 6200000, 6500000, 6300000, 6800000],
      "color": "#0078D4"
    },
    {
      "label": "Gross Profit",
      "data": [180000, 190000, 220000, 205000, 240000, 260000, 270000, 280000, 270000, 290000],
      "color": "#107C10"
    }
  ]
}
{{/VISUALIZATION_DATA}}

Now analyze the provided Excel data and create your visualization following this exact format.
""";

          final textWithInstructions =
              "$currentText\n\n$visualizationInstructions";

          apiContents[lastIdx] = Content(
            role: "user",
            parts: [Part.text(textWithInstructions)],
          );
        }
      }

      final inputData = UnifiedAIInput(
        contents: apiContents,
        generationConfig: GenerationConfig(
          temperature: 0.2,
          maxOutputTokens: 2048,
        ),
        model: state.selectedModel?.modelId,
      );

      talker.info(
        'ExcelAnalysis: Calling AI API with model: ${state.selectedModel?.name}...',
      );

      // Use dynamic model URL and Key
      final model = state.selectedModel;
      if (model == null) throw Exception('No AI model selected');

      // Use the generic AI provider
      final response = await ref.read(
        geminiResponseProvider(inputData, model).future,
      );

      if (!ref.mounted) {
        talker.warning('ExcelAnalysis: Provider unmounted, aborting');
        return;
      }

      talker.info('ExcelAnalysis: Got response (${response.length} chars)');

      // Extract visualization data if present
      String? vizData;
      String cleanedResponse = response;

      if (response.contains('{{VISUALIZATION_DATA}}')) {
        final startTag = '{{VISUALIZATION_DATA}}';
        final endTag = '{{/VISUALIZATION_DATA}}';

        final startIdx = response.indexOf(startTag);
        final endIdx = response.indexOf(endTag);

        if (startIdx != -1 && endIdx != -1 && endIdx > startIdx) {
          // Extract the full block including markers (needed for StructuredDataVisualization)
          vizData = response.substring(startIdx, endIdx + endTag.length);

          // Safety fix: The visualization widget only supports specific types.
          // If the AI invents 'line_chart' or 'bar_chart', map them to 'financial_report' which handles them.
          if (vizData.contains('"type": "line_chart"') ||
              vizData.contains('"type": "bar_chart"') ||
              vizData.contains('"type": "pie_chart"')) {
            vizData = vizData.replaceAll(
              RegExp(r'"type":\s*"(line|bar|pie)_chart"'),
              '"type": "financial_report"',
            );
            talker.warning(
              'ExcelAnalysis: Corrected visualization type to financial_report',
            );
          }

          talker.info(
            'ExcelAnalysis: Extracted visualization data with markers',
          );

          // Remove the visualization block from the response shown in chat
          cleanedResponse = response
              .replaceAll(
                RegExp(
                  r'\{\{VISUALIZATION_DATA\}\}.*?\{\{/VISUALIZATION_DATA\}\}',
                  dotAll: true,
                ),
                '',
              )
              .trim();
        }
      }

      final assistantMessage = Content(
        role: "model",
        parts: [Part.text(cleanedResponse)],
      );

      state = state.copyWith(
        history: [...newHistory, assistantMessage],
        lastVisualizationData: vizData ?? state.lastVisualizationData,
        isLoading: false,
      );

      talker.info(
        'ExcelAnalysis: State updated, history length: ${state.history.length}',
      );
    } catch (e, stack) {
      if (e.toString().contains('Provider disposed')) {
        talker.info('ExcelAnalysis: Operation cancelled (provider disposed)');
        return;
      }
      talker.error('ExcelAnalysis: Analysis failed: $e');
      talker.error(stack);
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: _parseFriendlyError(e));
    }
  }
}

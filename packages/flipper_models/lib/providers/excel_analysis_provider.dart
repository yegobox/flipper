import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/utils/excel_utility.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flipper_models/models/ai_model.dart';
import 'package:flipper_models/repositories/ai_model_repository.dart';
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

  ExcelAnalysisState({
    this.history = const [],
    this.isLoading = false,
    this.error,
    this.lastVisualizationData,
    this.excelData = const {},
    this.filePath,
    this.availableModels = const [],
    this.selectedModel,
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

  Future<void> initWithFile(String filePath) async {
    talker.info('ExcelAnalysis: Initializing with file: $filePath');
    state = state.copyWith(isLoading: true, filePath: filePath);
    try {
      final data = await ExcelUtility.excelToData(filePath);
      talker.info('ExcelAnalysis: Extracted ${data.length} sheets');

      final markdown = await ExcelUtility.excelToMarkdown(filePath);
      talker
          .info('ExcelAnalysis: Generated markdown (${markdown.length} chars)');

      final repository = AIModelRepository();
      // Use Business ID 1 for now (or fetch actual business ID)
      final models = await repository.getAvailableModels();
      final defaultModel = await repository.getDefaultModel();

      state = state.copyWith(
        excelData: data,
        history: [],
        availableModels: models,
        selectedModel: defaultModel,
        isLoading: false,
      );

      // Trigger initial AI response with context
      await analyzeMessage(
          "I have uploaded an Excel file for analysis. Here is the data in Markdown format:\n\n$markdown\n\nPlease analyze this data and give me a brief summary of what's inside.");
    } catch (e, stack) {
      talker.error('ExcelAnalysis: Init failed: $e');
      talker.error(stack);
      state = state.copyWith(
        isLoading: false,
        error: _parseFriendlyError(e),
      );
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

    final userMessage = Content(
      role: "user",
      parts: [Part.text(userPrompt)],
    );

    final newHistory = [...state.history, userMessage];

    state = state.copyWith(
      history: newHistory,
      isLoading: true,
      error: null,
    );

    try {
      final inputData = UnifiedAIInput(
        contents: newHistory,
        generationConfig: GenerationConfig(
          temperature: 0.2,
          maxOutputTokens: 2048,
        ),
        model: state.selectedModel?.modelId,
      );

      talker.info(
          'ExcelAnalysis: Calling AI API with model: ${state.selectedModel?.name}...');

      // Use dynamic model URL and Key
      final model = state.selectedModel;
      if (model == null) throw Exception('No AI model selected');

      // Use the generic AI provider
      final response =
          await ref.read(geminiResponseProvider(inputData, model).future);

      if (!ref.mounted) {
        talker.warning('ExcelAnalysis: Provider unmounted, aborting');
        return;
      }

      talker.info('ExcelAnalysis: Got response (${response.length} chars)');

      final assistantMessage = Content(
        role: "model",
        parts: [Part.text(response)],
      );

      // Extract visualization data if present
      String? vizData;
      if (response.contains('{{VISUALIZATION_DATA}}')) {
        final start = response.indexOf('{{VISUALIZATION_DATA}}') +
            '{{VISUALIZATION_DATA}}'.length;
        final end = response.indexOf('{{/VISUALIZATION_DATA}}');
        if (end > start) {
          vizData = response.substring(start, end).trim();
          talker.info('ExcelAnalysis: Extracted visualization data');
        }
      }

      state = state.copyWith(
        history: [...newHistory, assistantMessage],
        lastVisualizationData: vizData ?? state.lastVisualizationData,
        isLoading: false,
      );

      talker.info(
          'ExcelAnalysis: State updated, history length: ${state.history.length}');
    } catch (e, stack) {
      if (e.toString().contains('Provider disposed')) {
        talker.info('ExcelAnalysis: Operation cancelled (provider disposed)');
        return;
      }
      talker.error('ExcelAnalysis: Analysis failed: $e');
      talker.error(stack);
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: _parseFriendlyError(e),
      );
    }
  }
}

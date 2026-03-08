// src/providers/ai_provider.dart
/// AI Providers - Re-export from flipper_models
///
/// The actual AI provider implementations (Riverpod) are in flipper_models
/// This package re-exports them for convenience.

export 'package:flipper_models/providers/ai_provider.dart'
    show
        availableModels,
        geminiResponse,
        GeminiResponse,
        geminiBusinessAnalytics,
        GeminiBusinessAnalytics,
        geminiSummary,
        streamedBusinessAnalytics;

// TODO: Migrate full provider implementations here from:
// flipper_models/lib/providers/ai_provider.dart

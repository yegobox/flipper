import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/ai_model.dart';
import 'package:flipper_models/repositories/ai_model_repository.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract contract for an on-device LLM inference engine.
///
/// `flipper_models` is a low-level package and must stay free of platform
/// plugins (e.g. `flutter_gemma`). The concrete implementation lives in the
/// feature layer and is registered at app bootstrap via
/// [LocalInferenceRegistry.register]. On platforms where on-device inference
/// is unavailable, no engine is registered and callers fall back to cloud.
abstract class LocalInferenceEngine {
  /// Whether on-device inference is supported on this platform/device.
  bool get isSupported;

  /// Whether the model weights are downloaded and the engine is initialised.
  bool get isReady;

  /// Ensure the model weights are downloaded and the engine is initialised.
  ///
  /// [onProgress] reports download progress in the range 0.0..1.0 while the
  /// weights are being fetched. Safe to call repeatedly; implementations should
  /// no-op once ready.
  Future<void> ensureModelReady({void Function(double progress)? onProgress});

  /// Stream response chunks for [prompt] as they are produced.
  Stream<String> generate(
    String prompt, {
    double? temperature,
    int? maxTokens,
  });

  /// One-shot completion. Implementations may collect [generate] internally.
  Future<String> complete(
    String prompt, {
    double? temperature,
    int? maxTokens,
  });

  // === On-device RAG (Phase 2) ===

  /// Whether on-device retrieval (embedder + vector store) is available.
  bool get supportsRag;

  /// Install the embedder and open the on-device vector store. Idempotent.
  Future<void> ensureRagReady({void Function(double progress)? onProgress});

  /// Upsert [docs] into the on-device vector store (embeddings computed
  /// on-device). Safe to call with already-indexed ids.
  Future<void> indexDocuments(List<RagDocument> docs);

  /// Retrieve the [topK] documents most similar to [query].
  Future<List<RagHit>> retrieve(String query, {int topK = 5});

  /// Number of documents currently in the vector store (0 if unavailable).
  Future<int> ragDocumentCount();
}

/// A document to index for on-device retrieval. Plugin-free value type so the
/// vector-store plugin never leaks into `flipper_models`.
class RagDocument {
  const RagDocument({required this.id, required this.content, this.metadata});

  final String id;
  final String content;
  final String? metadata;
}

/// A retrieved document with its similarity score.
class RagHit {
  const RagHit({
    required this.content,
    required this.similarity,
    this.metadata,
  });

  final String content;
  final double similarity;
  final String? metadata;
}

/// Process-wide holder for the app-registered [LocalInferenceEngine].
///
/// Stays `null` on platforms where on-device AI is unavailable or where no
/// engine was registered. Use [isAvailable] to gate local routing/UI.
class LocalInferenceRegistry {
  LocalInferenceRegistry._();

  static LocalInferenceEngine? _engine;

  /// Register the engine implementation. Call once at app bootstrap.
  static void register(LocalInferenceEngine engine) {
    _engine = engine;
    talker.info(
      'LocalInferenceRegistry: registered ${engine.runtimeType} '
      '(supported=${engine.isSupported})',
    );
  }

  /// The registered engine, or null if none/unsupported on this platform.
  static LocalInferenceEngine? get engine => _engine;

  /// True when an engine is registered AND supported on this device.
  static bool get isAvailable => _engine != null && _engine!.isSupported;
}

/// Pick the default model for the current platform + subscription tier.
///
/// - Free/low tier on a local-capable device → prefer an on-device model.
/// - Paid tier (pro/enterprise) → prefer the cloud default.
/// - Otherwise → fall back to the configured default (already sorted first).
///
/// [models] is expected to be the platform-visible list (local models already
/// filtered out where unsupported).
AIModel? pickDefaultModel(
  List<AIModel> models, {
  required bool isPaidTier,
  required bool localSupported,
}) {
  if (models.isEmpty) return null;

  AIModel? firstWhereOrNull(bool Function(AIModel) test) {
    for (final m in models) {
      if (test(m)) return m;
    }
    return null;
  }

  if (!isPaidTier && localSupported) {
    // Free tier on a capable device: default to on-device (no cloud cost).
    final localDefault = firstWhereOrNull((m) => m.isLocal && m.isDefault);
    final anyLocal = firstWhereOrNull((m) => m.isLocal);
    final picked = localDefault ?? anyLocal;
    if (picked != null) return picked;
  }

  // Paid tier (or no local available): prefer the cloud default.
  final cloudDefault = firstWhereOrNull((m) => !m.isLocal && m.isDefault);
  final anyCloud = firstWhereOrNull((m) => !m.isLocal);
  return cloudDefault ?? anyCloud ?? models.first;
}

/// Resolves the tier-aware default [AIModel] for the active business.
///
/// Reads the platform-visible models, the on-device capability, and the active
/// business subscription, then delegates to [pickDefaultModel].
final defaultAiModelProvider = FutureProvider<AIModel?>((ref) async {
  final repo = AIModelRepository();
  final allModels = await repo.getAvailableModels();
  final localSupported = LocalInferenceRegistry.isAvailable;

  // Hide on-device models on platforms/devices that can't run them.
  final visible = allModels
      .where((m) => !m.isLocal || localSupported)
      .toList(growable: false);
  if (visible.isEmpty) return null;

  var isPaidTier = false;
  try {
    final business =
        await ProxyService.getStrategy(Strategy.capella).activeBusiness();
    isPaidTier = business?.subscriptionPlan == 'pro' ||
        business?.subscriptionPlan == 'enterprise';
  } catch (e) {
    talker.warning('defaultAiModelProvider: tier lookup failed: $e');
  }

  return pickDefaultModel(
    visible,
    isPaidTier: isPaidTier,
    localSupported: localSupported,
  );
});

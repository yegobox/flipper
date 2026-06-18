import 'dart:async';
import 'dart:ffi' show Abi;

import 'package:flutter/foundation.dart';
import 'package:flipper_models/providers/local_inference_engine.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'local_ai_config.dart';

/// `flutter_gemma`-backed implementation of [LocalInferenceEngine].
///
/// Lives in the feature layer so the plugin dependency never leaks into
/// `flipper_models`. Register once at app bootstrap via
/// [LocalInferenceRegistry.register]. On unsupported platforms [isSupported]
/// is false and the registry treats it as unavailable.
class GemmaInferenceEngine implements LocalInferenceEngine {
  GemmaInferenceEngine();

  bool _ready = false;
  Future<void>? _initFuture;
  dynamic _model; // InferenceModel from flutter_gemma

  /// CPU/OS combos for which `flutter_gemma` ships a native LiteRT-LM library.
  /// Critically, macOS and iOS are **arm64 only** — there is NO x86_64 macOS
  /// build and no Intel iOS-simulator build, so Intel Macs must fall back to
  /// cloud rather than register an engine that crashes at `dlopen`.
  static const Set<Abi> _supportedAbis = {
    Abi.macosArm64,
    Abi.iosArm64,
    Abi.windowsX64,
    Abi.windowsArm64,
    Abi.linuxX64,
    Abi.linuxArm64,
  };

  /// On-device inference is gated to iOS + desktop (per product decision) AND
  /// to architectures with a shipped native library. Android, web, and Intel
  /// macOS / Intel iOS-simulator fall back to cloud.
  @override
  bool get isSupported {
    if (kIsWeb) return false;
    return _supportedAbis.contains(Abi.current());
  }

  @override
  bool get isReady => _ready;

  @override
  Future<void> ensureModelReady({
    void Function(double progress)? onProgress,
  }) {
    if (_ready) return Future.value();
    // Coalesce concurrent callers onto a single init.
    return _initFuture ??= _initialize(onProgress).whenComplete(() {
      _initFuture = null;
    });
  }

  Future<void> _initialize(void Function(double)? onProgress) async {
    if (!isSupported) {
      throw StateError('On-device AI is not supported on this platform.');
    }

    // Download + install the weights if not already present, reporting
    // progress (0.0..1.0). install() is a no-op once the file is cached.
    // fileType MUST be litertlm — it defaults to .task (MediaPipe), which the
    // desktop LiteRT-LM engine cannot handle.
    await FlutterGemma.installModel(
      modelType: ModelType.gemmaIt,
      fileType: ModelFileType.litertlm,
    )
        .fromNetwork(
          LocalAiConfig.modelUrl,
          token: LocalAiConfig.modelToken.isEmpty
              ? null
              : LocalAiConfig.modelToken,
        )
        .withProgress((percent) => onProgress?.call(percent / 100.0))
        .install();

    _model = await FlutterGemma.getActiveModel(
      maxTokens: LocalAiConfig.maxTokens,
      preferredBackend: PreferredBackend.gpu,
    );
    _ready = true;
  }

  @override
  Stream<String> generate(
    String prompt, {
    double? temperature,
    int? maxTokens,
  }) async* {
    await ensureModelReady();
    // Fresh, stateless session per request — avoids context bleed between
    // unrelated lightweight queries.
    final chat = await _model.openChat();
    await chat.addQueryChunk(Message.text(text: prompt, isUser: true));

    await for (final response in chat.generateChatResponseAsync()) {
      if (response is TextResponse) {
        yield response.token;
      }
      // FunctionCall / Thinking responses are ignored in the lightweight tier.
    }
  }

  @override
  Future<String> complete(
    String prompt, {
    double? temperature,
    int? maxTokens,
  }) async {
    final buffer = StringBuffer();
    await for (final chunk in generate(
      prompt,
      temperature: temperature,
      maxTokens: maxTokens,
    )) {
      buffer.write(chunk);
    }
    return buffer.toString().trim();
  }

  // === On-device RAG ===

  bool _ragReady = false;
  Future<void>? _ragInitFuture;

  @override
  bool get supportsRag => isSupported;

  @override
  Future<void> ensureRagReady({void Function(double progress)? onProgress}) {
    if (_ragReady) return Future.value();
    return _ragInitFuture ??= _initRag(onProgress).whenComplete(() {
      _ragInitFuture = null;
    });
  }

  Future<void> _initRag(void Function(double)? onProgress) async {
    if (!supportsRag) {
      throw StateError('On-device RAG is not supported on this platform.');
    }

    // Install the embedding model + tokenizer (no-op if already cached).
    // EmbeddingGemma requires both the .tflite weights and its SentencePiece
    // tokenizer.
    final embedToken =
        LocalAiConfig.modelToken.isEmpty ? null : LocalAiConfig.modelToken;
    await FlutterGemma.installEmbedder()
        .modelFromNetwork(LocalAiConfig.embedderUrl, token: embedToken)
        .tokenizerFromNetwork(
          LocalAiConfig.embedderTokenizerUrl,
          token: embedToken,
        )
        .withModelProgress((percent) => onProgress?.call(percent / 100.0))
        .install();

    // Open the on-device vector store next to other app support files.
    final dir = await getApplicationSupportDirectory();
    final dbPath = p.join(dir.path, LocalAiConfig.vectorDbName);
    await FlutterGemmaPlugin.instance.initializeVectorStore(dbPath);
    _ragReady = true;
  }

  @override
  Future<void> indexDocuments(List<RagDocument> docs) async {
    if (docs.isEmpty) return;
    await ensureRagReady();
    for (final doc in docs) {
      await FlutterGemmaPlugin.instance.addDocument(
        id: doc.id,
        content: doc.content,
        metadata: doc.metadata,
      );
    }
  }

  @override
  Future<List<RagHit>> retrieve(String query, {int topK = 5}) async {
    await ensureRagReady();
    final results = await FlutterGemmaPlugin.instance.searchSimilar(
      query: query,
      topK: topK,
    );
    return results
        .map((r) => RagHit(
              content: r.content,
              similarity: r.similarity,
              metadata: r.metadata,
            ))
        .toList(growable: false);
  }

  @override
  Future<int> ragDocumentCount() async {
    if (!_ragReady) return 0;
    try {
      final stats = await FlutterGemmaPlugin.instance.getVectorStoreStats();
      return stats.documentCount;
    } catch (_) {
      return 0;
    }
  }
}

import 'dart:async';
import 'dart:ffi' show Abi;
import 'dart:io' show Directory, File, IOSink, Platform;

import 'package:flutter/foundation.dart';
import 'package:flipper_models/providers/local_inference_engine.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:http/http.dart' as http;
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

    // Ensure the weights exist at an app-owned, guaranteed-absolute path, then
    // install via `.fromFile`. We deliberately do NOT use flutter_gemma's
    // `.fromNetwork` installer: on Windows its storage dir is resolved from the
    // `%LOCALAPPDATA%` env var, which can arrive relative and makes the plugin
    // download to / validate against CWD-relative "ghost" dirs → the model
    // never validates ("Active model is no longer installed"). `.fromFile`
    // feeds our absolute path verbatim to both validation and the engine,
    // sidestepping all of that. See [_ensureModelFile].
    final modelPath = await _ensureModelFile(onProgress);

    // fileType MUST be litertlm — it defaults to .task (MediaPipe), which the
    // desktop LiteRT-LM engine cannot handle.
    await FlutterGemma.installModel(
      modelType: ModelType.gemmaIt,
      fileType: ModelFileType.litertlm,
    ).fromFile(modelPath).install();

    // Use CPU: the desktop LiteRT-LM GPU delegate frequently initializes but
    // then yields zero tokens (most Windows/Linux boxes have no usable GPU
    // delegate), which presents as "no response". CPU is the safe default.
    _model = await FlutterGemma.getActiveModel(
      maxTokens: LocalAiConfig.maxTokens,
      preferredBackend: PreferredBackend.cpu,
    );
    _ready = true;
  }

  /// Guarantees the weights exist at an app-owned, absolute path and returns
  /// it. Resolution order:
  ///   1. Already in our stable store ([_modelStoreDir]) → use it.
  ///   2. Present in a legacy/plugin location (incl. the CWD-relative "ghost"
  ///      dir from earlier `.fromNetwork` runs) → migrate (copy) into the store
  ///      to avoid a multi-hundred-MB re-download.
  ///   3. Otherwise download it ourselves (streaming, with progress) into the
  ///      store.
  /// The store lives under path_provider's Application Support dir, which is
  /// resolved via the OS known-folder API (absolute & stable on every
  /// platform) — unlike flutter_gemma's `%LOCALAPPDATA%`-env resolution.
  Future<String> _ensureModelFile(void Function(double)? onProgress) async {
    final filename = p.basename(Uri.parse(LocalAiConfig.modelUrl).path);
    final dir = await _modelStoreDir();
    final finalFile = File(p.join(dir, filename));

    if (await _isValidModel(finalFile)) {
      return finalFile.path;
    }

    final legacy = await _existingLegacyModelPath(filename);
    if (legacy != null) {
      debugPrint('[GemmaInferenceEngine] migrating weights into store: '
          '$legacy -> ${finalFile.path}');
      await File(legacy).copy(finalFile.path);
      return finalFile.path;
    }

    debugPrint('[GemmaInferenceEngine] downloading weights to ${finalFile.path}');
    await _downloadModel(finalFile, onProgress);
    return finalFile.path;
  }

  /// App-owned, stable, absolute model directory.
  Future<String> _modelStoreDir() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory(p.join(base.path, 'flo_models'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }

  Future<bool> _isValidModel(File f) async {
    try {
      // 1 MB floor mirrors the plugin's own sanity check; guards against
      // partial/empty files masquerading as a complete model.
      return await f.exists() && await f.length() > 1024 * 1024;
    } catch (_) {
      return false;
    }
  }

  /// Streams [LocalAiConfig.modelUrl] to [dest] via a `.part` temp file, then
  /// atomically renames on success. Sends the HuggingFace token when set.
  Future<void> _downloadModel(
    File dest,
    void Function(double)? onProgress,
  ) async {
    final tmp = File('${dest.path}.part');
    if (await tmp.exists()) await tmp.delete();

    final client = http.Client();
    IOSink? sink;
    try {
      final req = http.Request('GET', Uri.parse(LocalAiConfig.modelUrl));
      final token = LocalAiConfig.modelToken;
      if (token.isNotEmpty) req.headers['Authorization'] = 'Bearer $token';

      final resp = await client.send(req);
      if (resp.statusCode != 200) {
        throw StateError('Model download failed: HTTP ${resp.statusCode}');
      }

      final total = resp.contentLength ?? 0;
      var received = 0;
      sink = tmp.openWrite();
      await for (final chunk in resp.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0) onProgress?.call(received / total);
      }
      await sink.flush();
      await sink.close();
      sink = null;

      if (!await _isValidModel(tmp)) {
        throw StateError('Downloaded model is too small / incomplete.');
      }
      // Replace any stale destination, then promote the temp file.
      if (await dest.exists()) await dest.delete();
      await tmp.rename(dest.path);
    } finally {
      await sink?.close();
      if (await tmp.exists()) await tmp.delete();
      client.close();
    }
  }

  /// Looks for the weights in legacy/plugin-managed locations (so an existing
  /// download can be migrated into the store instead of re-fetched). Returns
  /// the first valid (≥1 MB) absolute path, else null.
  Future<String?> _existingLegacyModelPath(String filename) async {
    for (final dir in await _candidateStorageDirs()) {
      try {
        final file = File(p.join(dir, filename));
        if (await _isValidModel(file)) return file.path;
      } catch (_) {
        // Skip unreadable candidate.
      }
    }
    return null;
  }

  /// Guaranteed-absolute candidate dirs where the weights may already live,
  /// most-canonical first. We do NOT trust `LOCALAPPDATA` unless it is
  /// absolute; otherwise we reconstruct the canonical Windows location from
  /// `USERPROFILE` (which is reliably absolute), and finally fall back to
  /// path_provider's Application Support dir.
  Future<List<String>> _candidateStorageDirs() async {
    final dirs = <String>[];
    if (Platform.isWindows) {
      final local = Platform.environment['LOCALAPPDATA'];
      if (local != null && local.isNotEmpty) {
        if (p.isAbsolute(local)) {
          dirs.add(p.join(local, 'flutter_gemma'));
        } else {
          // CRITICAL: when LOCALAPPDATA is relative, flutter_gemma's own dir
          // resolution joins it against the process CWD — so the weights it
          // downloaded actually live under <cwd>/<LOCALAPPDATA>/flutter_gemma
          // (a "ghost" dir nested in the project). Follow the bug to where the
          // real files are, rather than guessing the canonical location.
          dirs.add(p.join(Directory.current.path, local, 'flutter_gemma'));
        }
      }
      final home = Platform.environment['USERPROFILE'];
      if (home != null && home.isNotEmpty && p.isAbsolute(home)) {
        dirs.add(p.join(home, 'AppData', 'Local', 'flutter_gemma'));
        // The env var is UNRELIABLE across launches: when LOCALAPPDATA came
        // through relative on a *previous* run, flutter_gemma downloaded the
        // weights into a CWD-relative "ghost" dir nested in the project
        // (<cwd>/Users/<user>/AppData/Local/flutter_gemma). install() never
        // re-downloads (stale metadata says "already installed"), so that
        // ghost copy is the ONLY real one on disk. Reconstruct it from
        // USERPROFILE (drive stripped) joined against the current CWD and
        // always check it, regardless of this run's LOCALAPPDATA state.
        final rel = home.replaceFirst(RegExp(r'^[A-Za-z]:[\\/]*'), '');
        if (rel.isNotEmpty) {
          dirs.add(p.join(
            Directory.current.path,
            rel,
            'AppData',
            'Local',
            'flutter_gemma',
          ));
        }
      }
    }
    try {
      final base = await getApplicationSupportDirectory();
      dirs.add(p.join(base.path, 'flutter_gemma'));
    } catch (_) {
      // path_provider may be unavailable very early; the env paths cover us.
    }
    // De-dupe while preserving order.
    return dirs.toSet().toList(growable: false);
  }

  @override
  Stream<String> generate(
    String prompt, {
    double? temperature,
    int? maxTokens,
  }) async* {
    await ensureModelReady();
    // Fresh, stateless session per request — avoids context bleed between
    // unrelated lightweight queries. Low temperature keeps answers factual and
    // grounded in the provided shop data (the default 0.8 is too creative for
    // data Q&A and encourages made-up numbers/items).
    final chat = await _model.openChat(temperature: temperature ?? 0.3);
    await chat.addQueryChunk(Message.text(text: prompt, isUser: true));

    await for (final response in chat.generateChatResponseAsync()) {
      if (response is TextResponse) {
        yield response.token;
      }
      // Non-text responses (FunctionCall / Thinking) are ignored in the
      // lightweight tier.
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

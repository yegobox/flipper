import 'package:flipper_models/providers/local_inference_engine.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';
import 'package:flutter_gemma_embeddings/flutter_gemma_embeddings.dart';
import 'package:flutter_gemma_rag_qdrant/flutter_gemma_rag_qdrant.dart';

import 'gemma_inference_engine.dart';
import 'local_ai_config.dart';

/// Initialise on-device AI and register the engine.
///
/// Call once at app bootstrap (in `main()`), after `WidgetsFlutterBinding`.
/// On Android/web (or any unsupported device) this is a no-op, so those users
/// transparently stay on the cloud path. Weights are NOT downloaded here — the
/// engine lazily fetches them on first use via [GemmaInferenceEngine.ensureModelReady].
void initLocalAi() {
  final engine = GemmaInferenceEngine();
  if (!engine.isSupported) return;

  FlutterGemma.initialize(
    inferenceEngines: const [LiteRtLmEngine()],
    // On-device RAG: embedding backend + qdrant-edge vector store.
    embeddingBackends: const [LiteRtEmbeddingBackend()],
    vectorStore: QdrantVectorStore(),
    // Authenticates gated HuggingFace downloads. Ignored when weights are
    // self-hosted (token empty).
    huggingFaceToken:
        LocalAiConfig.modelToken.isEmpty ? null : LocalAiConfig.modelToken,
  );
  LocalInferenceRegistry.register(engine);
}

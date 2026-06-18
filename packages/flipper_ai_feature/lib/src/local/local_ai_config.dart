import 'package:flipper_models/secrets.dart';

/// Configuration for on-device (Gemma) inference.
///
/// Weights are NOT bundled in the binary — they are downloaded once on first
/// use and cached. Two sourcing options (toggle by changing [modelUrl]):
///
///  - **HuggingFace (default here):** pull the gated Gemma `.litertlm` directly
///    from HuggingFace. Requires [modelToken] (your HF access token). NOTE: the
///    token ships in the app binary and is extractable — fine for internal
///    builds, but for production prefer self-hosting (below) or a download proxy.
///  - **Self-hosted:** accept the Gemma licence once, mirror the `.litertlm`
///    file to your own bucket/CDN, point [modelUrl] there, and leave the token
///    empty (no HuggingFace gating, nothing sensitive in the binary).
///
/// Override either value at build time with --dart-define.
class LocalAiConfig {
  const LocalAiConfig._();

  /// `.litertlm` model URL. Default is the HuggingFace LiteRT community mirror
  /// of Gemma3 1B IT, which `flutter_gemma_litertlm` runs on both iOS and
  /// desktop. Replace with a self-hosted URL to drop the HuggingFace token.
  static const String modelUrl = String.fromEnvironment(
    'FLIPPER_LOCAL_MODEL_URL',
    defaultValue:
        'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.litertlm',
  );

  /// Access token for the weights host. Defaults to the HuggingFace token from
  /// secrets; a `--dart-define` overrides it. Empty when self-hosting on an
  /// ungated bucket.
  static const String _tokenOverride =
      String.fromEnvironment('FLIPPER_LOCAL_MODEL_TOKEN', defaultValue: '');

  static String get modelToken =>
      _tokenOverride.isNotEmpty ? _tokenOverride : AppSecrets.huggingFaceToken;

  /// Context window for the on-device model. Kept modest for memory headroom.
  static const int maxTokens = 2048;

  // === On-device RAG (Phase 2) ===

  /// EmbeddingGemma weights for on-device embeddings. Same token rules as the
  /// chat model. Override with --dart-define for a self-hosted mirror.
  static const String embedderUrl = String.fromEnvironment(
    'FLIPPER_LOCAL_EMBEDDER_URL',
    defaultValue:
        'https://huggingface.co/litert-community/embeddinggemma-300m/resolve/main/embeddinggemma-300M_seq256_mixed-precision.tflite',
  );

  /// Tokenizer for the embedder (EmbeddingGemma uses a SentencePiece model).
  /// Required alongside [embedderUrl].
  static const String embedderTokenizerUrl = String.fromEnvironment(
    'FLIPPER_LOCAL_EMBEDDER_TOKENIZER_URL',
    defaultValue:
        'https://huggingface.co/litert-community/embeddinggemma-300m/resolve/main/sentencepiece.model',
  );

  /// Filename of the on-device vector store database (qdrant-edge).
  static const String vectorDbName = 'flipper_sales_rag.db';

  /// How many retrieved rows to inject into the local prompt.
  static const int ragTopK = 5;
}

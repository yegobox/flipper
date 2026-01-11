import 'package:dart_mappable/dart_mappable.dart';

part 'ai_model.mapper.dart';

@MappableClass()
class AIModel with AIModelMappable {
  final String id;
  final String name;
  final String modelId;
  final String provider;
  final String apiUrl;
  final String? apiKey;
  final bool isActive;
  final bool isDefault;
  @MappableField(key: 'is_paid_only')
  final bool isPaidOnly;
  final String? apiStandard;
  final int maxTokens;
  final double temperature;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AIModel({
    required this.id,
    required this.name,
    required this.modelId,
    required this.provider,
    required this.apiUrl,
    this.apiKey,
    this.isActive = true,
    this.isDefault = false,
    this.isPaidOnly = false, // Default to false
    this.apiStandard,
    this.maxTokens = 2048,
    this.temperature = 0.2,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from Supabase JSON
  factory AIModel.fromJson(Map<String, dynamic> json) {
    return AIModel(
      id: json['id'] as String,
      name: json['name'] as String,
      modelId: json['model_id'] as String,
      provider: json['provider'] as String,
      apiUrl: json['api_url'] as String,
      apiKey: json['api_key'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isDefault: json['is_default'] as bool? ?? false,
      isPaidOnly: json['is_paid_only'] as bool? ?? false,
      apiStandard: json['api_standard'] as String?,
      maxTokens: json['max_tokens'] as int? ?? 2048,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.2,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model_id': modelId,
      'provider': provider,
      'api_url': apiUrl,
      'api_key': apiKey,
      'is_active': isActive,
      'is_default': isDefault,
      'is_paid_only': isPaidOnly,
      'api_standard': apiStandard,
      'max_tokens': maxTokens,
      'temperature': temperature,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Check if model uses OpenAI standard (Bearer token)
  bool get isOpenAIStandard => apiStandard == 'openai';

  /// Check if model uses Gemini standard (URL key)
  bool get isGeminiStandard => apiStandard == 'gemini' || apiStandard == null;
}

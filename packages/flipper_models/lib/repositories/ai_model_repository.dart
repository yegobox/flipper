import 'package:flipper_models/models/ai_model.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/business_ai_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AIModelRepository {
  AIModelRepository();

  /// Get all available AI models
  /// Returns global models
  Future<List<AIModel>> getAvailableModels() async {
    try {
      talker.info('AIModelRepository: Fetching available models');

      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('ai_models')
          .select()
          .eq('is_active', true)
          .order('is_default', ascending: false)
          .order('name', ascending: true);

      final models = (response as List)
          .map((json) => AIModel.fromJson(json as Map<String, dynamic>))
          .toList();

      talker.info('AIModelRepository: Found ${models.length} models');
      return models;
    } catch (e, stack) {
      talker.error('AIModelRepository: Failed to fetch models: $e');
      talker.error(stack);
      return [];
    }
  }

  /// Get the default global model
  Future<AIModel?> getDefaultModel() async {
    try {
      final models = await getAvailableModels();
      return models.firstWhere(
        (m) => m.isDefault,
        orElse: () => models.isNotEmpty
            ? models.first
            : throw Exception('No models available'),
      );
    } catch (e) {
      talker.error('AIModelRepository: Failed to get default model: $e');
      return null;
    }
  }

  /// Get AI configuration for a business (creates row if missing).
  Future<BusinessAIConfig?> getBusinessConfig(String businessId) async {
    try {
      final supabase = Supabase.instance.client;

      var row = await supabase
          .from('business_ai_configs')
          .select()
          .eq('business_id', businessId)
          .maybeSingle();

      if (row == null) {
        try {
          row = await supabase
              .from('business_ai_configs')
              .insert({
                'business_id': businessId,
                'usage_limit': 100,
                'current_usage': 0,
                'ai_model_id': null,
              })
              .select()
              .single();
        } catch (_) {
          row = await supabase
              .from('business_ai_configs')
              .select()
              .eq('business_id', businessId)
              .maybeSingle();
        }
      }

      if (row == null) return null;
      return _businessConfigFromRow(Map<String, dynamic>.from(row));
    } catch (e) {
      talker.error('AIModelRepository: Failed to get business config: $e');
      return null;
    }
  }

  /// Whether background lead catalogue AI matching is enabled (Supabase).
  /// Defaults to true when unset or config missing.
  Future<bool> isLeadsAiMatchEnabledForBusiness(String businessId) async {
    final config = await getBusinessConfig(businessId);
    return config?.leadsAiMatchEnabled ?? true;
  }

  BusinessAIConfig _businessConfigFromRow(Map<String, dynamic> row) {
    return BusinessAIConfig(
      id: row['id'] as String,
      businessId: row['business_id'] as String,
      aiModelId: row['ai_model_id'] as String?,
      usageLimit: row['usage_limit'] as int? ?? 100,
      currentUsage: row['current_usage'] as int? ?? 0,
      leadsAiMatchEnabled: row['leads_ai_match_enabled'] as bool? ?? true,
      updatedAt: _parseUpdatedAt(row['updated_at']),
    );
  }

  DateTime _parseUpdatedAt(dynamic v) {
    if (v is DateTime) return v;
    if (v is String) return DateTime.parse(v);
    return DateTime.now().toUtc();
  }


  /// Increment usage for a business config
  Future<void> incrementUsage(String configId) async {
    try {
      final supabase = Supabase.instance.client;
      // Use RPC or direct update if simple increment is safe
      // For now simple update: read, increment, write (safer with RPC but this is MVP)
      // Actually, better to use SQL increment:
      await supabase.rpc('increment_ai_usage', params: {'config_id': configId});
      // Note: Need to create this RPC or use a raw query if possible with client
      // Alternately:
      // await supabase.from('business_ai_configs').update({'current_usage': currentUsage + 1}).eq('id', configId);
    } catch (e) {
      talker.error('AIModelRepository: Failed to increment usage: $e');
    }
  }

  /// Get a specific model by ID
  Future<AIModel?> getModelById(String modelId) async {
    try {
      final supabase = Supabase.instance.client;
      final response =
          await supabase.from('ai_models').select().eq('id', modelId).single();

      return AIModel.fromJson(response);
    } catch (e) {
      talker.error('AIModelRepository: Failed to fetch model $modelId: $e');
      return null;
    }
  }

  /// Create or update a model (admin function)
  Future<AIModel?> upsertModel(AIModel model) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('ai_models')
          .upsert(model.toMap())
          .select()
          .single();

      return AIModel.fromJson(response);
    } catch (e) {
      talker.error('AIModelRepository: Failed to upsert model: $e');
      return null;
    }
  }

  /// Delete a model (admin function)
  Future<bool> deleteModel(String modelId) async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('ai_models').delete().eq('id', modelId);
      return true;
    } catch (e) {
      talker.error('AIModelRepository: Failed to delete model: $e');
      return false;
    }
  }
}

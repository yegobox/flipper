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

  /// Get AI configuration for a business
  Future<BusinessAIConfig?> getBusinessConfig(String businessId) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('business_ai_configs')
          .select()
          .eq('business_id', businessId)
          .maybeSingle();

      if (response == null) {
        talker.warning(
            'AIModelRepository: No config found for business $businessId, creating default.');
        return await _createDefaultConfig(businessId);
      }

      // Manual mapping until mapper is generated/fixed
      return BusinessAIConfig(
        id: response['id'],
        businessId: response['business_id'],
        aiModelId: response['ai_model_id'],
        usageLimit: response['usage_limit'] ?? 100,
        currentUsage: response['current_usage'] ?? 0,
        updatedAt: DateTime.parse(response['updated_at']),
      );
    } catch (e) {
      talker.error('AIModelRepository: Failed to get business config: $e');
      return null;
    }
  }

  /// Create a default AI configuration for a business
  Future<BusinessAIConfig?> _createDefaultConfig(String businessId) async {
    try {
      talker.info(
          'AIModelRepository: Creating default config for business $businessId');
      final supabase = Supabase.instance.client;

      // Get default model if available, otherwise null (global default)
      // We don't strictly need to fetch it here if we just want to pass null,
      // but let's leave it null to use system default.

      final response = await supabase
          .from('business_ai_configs')
          .insert({
            'business_id': businessId,
            'usage_limit': 100, // Default limit
            'current_usage': 0,
            'ai_model_id': null, // Use global default
          })
          .select()
          .single();

      return BusinessAIConfig(
        id: response['id'],
        businessId: response['business_id'],
        aiModelId: response['ai_model_id'],
        usageLimit: response['usage_limit'] ?? 100,
        currentUsage: response['current_usage'] ?? 0,
        updatedAt: DateTime.parse(response['updated_at']),
      );
    } catch (e) {
      talker.error('AIModelRepository: Failed to create default config: $e');
      return null;
    }
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

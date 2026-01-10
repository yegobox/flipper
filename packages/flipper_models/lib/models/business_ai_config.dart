import 'package:dart_mappable/dart_mappable.dart';

part 'business_ai_config.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class BusinessAIConfig with BusinessAIConfigMappable {
  final String id;
  final String businessId;
  final String? aiModelId; // Null means use global default
  @MappableField(key: 'usage_limit')
  final int usageLimit;
  @MappableField(key: 'current_usage')
  final int currentUsage;
  final DateTime updatedAt;

  BusinessAIConfig({
    required this.id,
    required this.businessId,
    this.aiModelId,
    this.usageLimit = 100,
    this.currentUsage = 0,
    required this.updatedAt,
  });

  /// Check if usage limit is reached
  bool get isQuotaExceeded => currentUsage >= usageLimit;
}

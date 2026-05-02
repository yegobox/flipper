import 'package:flipper_models/models/business_ai_config.dart';
import 'package:test/test.dart';

void main() {
  test('constructor defaults leadsAiMatchEnabled to true', () {
    final c = BusinessAIConfig(
      id: '1',
      businessId: 'b',
      updatedAt: DateTime.utc(2024, 1, 1),
    );
    expect(c.leadsAiMatchEnabled, true);
  });

  test('fromMap without leads_ai_match_enabled defaults to true', () {
    final c = BusinessAIConfigMapper.fromMap({
      'id': 'x',
      'business_id': 'biz',
      'usage_limit': 100,
      'current_usage': 0,
      'updated_at': DateTime.utc(2024, 1, 1),
    });
    expect(c.leadsAiMatchEnabled, true);
  });

  test('fromMap with leads_ai_match_enabled false', () {
    final c = BusinessAIConfigMapper.fromMap({
      'id': 'x',
      'business_id': 'biz',
      'usage_limit': 100,
      'current_usage': 0,
      'leads_ai_match_enabled': false,
      'updated_at': DateTime.utc(2024, 1, 1),
    });
    expect(c.leadsAiMatchEnabled, false);
  });
}

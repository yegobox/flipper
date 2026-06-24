import 'package:flipper_models/leads/lead_ui_utils.dart';
import 'package:flipper_models/models/lead.dart';
import 'package:flipper_models/services/lead_ai_match_parser.dart';
import 'package:test/test.dart';

void main() {
  group('decodeLeadAiJsonObject', () {
    test('parses raw JSON object', () {
      final m = decodeLeadAiJsonObject('{"matches":[]}');
      expect(m, isNotNull);
      expect(m!['matches'], isA<List>());
    });

    test('strips markdown fence', () {
      final m = decodeLeadAiJsonObject('''
Here you go:
```json
{"matches":[{"query":"x","variantId":null,"quantity":1,"confidence":0.5}]}
```
''');
      expect(m, isNotNull);
      expect((m!['matches'] as List).length, 1);
    });

    test('strips reasoning wrapper', () {
      final m = decodeLeadAiJsonObject('''
{{REASONING}}
thinking
{{/REASONING}}
{"matches":[]}
''');
      expect(m, isNotNull);
    });

    test('returns null on garbage', () {
      expect(decodeLeadAiJsonObject('not json'), isNull);
    });
  });

  group('buildAiExtractedFromModelJson', () {
    test('validates variant ids against catalogue', () {
      final catalog = {
        'vid1': {
          'id': 'vid1',
          'name': 'Apple juice',
          'sku': 'AJ',
          'bcd': null,
          'unitPrice': 500.0,
        },
      };
      final built = buildAiExtractedFromModelJson(
        modelJson: {
          'matches': [
            {
              'query': 'juice',
              'variantId': 'vid1',
              'quantity': 2,
              'confidence': 0.9,
            },
            {
              'query': 'fake',
              'variantId': 'nope',
              'quantity': 1,
              'confidence': 0.8,
            },
          ],
        },
        catalogueById: catalog,
        sourceLabel: 'manual',
        modelLabel: 'test-model',
      );
      final matches = built.extracted['matches'] as List;
      expect(matches.length, 2);
      expect(matches[0]['variantId'], 'vid1');
      expect(matches[0]['unitPrice'], 500.0);
      expect(matches[1]['variantId'], isNull);
    });
  });

  group('lead_ui_utils', () {
    test('parseLeadItemRows prefers matches', () {
      final lead = Lead(
        id: 'l',
        branchId: 'b',
        businessId: 'biz',
        createdAt: DateTime.utc(2024),
        updatedAt: DateTime.utc(2024),
        lastTouched: DateTime.utc(2024),
        fullName: 'x',
        phoneNumber: null,
        emailAddress: null,
        source: LeadSource.walkIn,
        status: LeadStatus.newLead,
        heat: LeadHeat.hot,
        productsInterestedIn: 'a,b',
        estimatedValue: null,
        notes: null,
        externalThreadId: null,
        aiConfidence: 0.5,
        aiExtracted: {
          'matches': [
            {
              'variantName': 'Cat food',
              'query': 'food',
              'quantity': 3,
              'confidence': 0.88,
              'variantId': 'v',
            },
          ],
        },
      );
      final rows = parseLeadItemRows(lead);
      expect(rows.length, 1);
      expect(rows.first.title, 'Cat food');
      expect(rows.first.quantity, 3);
      expect(rows.first.matchPercent, closeTo(88.0, 0.01));
    });

    test('proformaSeedsFromLead uses unitPrice from matches', () {
      final lead = Lead(
        id: 'l',
        branchId: 'b',
        businessId: 'biz',
        createdAt: DateTime.utc(2024),
        updatedAt: DateTime.utc(2024),
        lastTouched: DateTime.utc(2024),
        fullName: 'x',
        phoneNumber: null,
        emailAddress: null,
        source: LeadSource.walkIn,
        status: LeadStatus.newLead,
        heat: LeadHeat.hot,
        productsInterestedIn: 'ignore',
        estimatedValue: 1000,
        notes: null,
        externalThreadId: null,
        aiConfidence: null,
        aiExtracted: {
          'matches': [
            {
              'variantName': 'Item A',
              'query': 'a',
              'quantity': 2,
              'unitPrice': 150.0,
            },
          ],
        },
      );
      final seeds = proformaSeedsFromLead(lead);
      expect(seeds.length, 1);
      expect(seeds.first.unitPrice, 150.0);
      expect(seeds.first.qty, 2);
    });

    test('proformaSeedsFromLead splits estimated value when no prices', () {
      final lead = Lead(
        id: 'l',
        branchId: 'b',
        businessId: 'biz',
        createdAt: DateTime.utc(2024),
        updatedAt: DateTime.utc(2024),
        lastTouched: DateTime.utc(2024),
        fullName: 'x',
        phoneNumber: null,
        emailAddress: null,
        source: LeadSource.walkIn,
        status: LeadStatus.newLead,
        heat: LeadHeat.hot,
        productsInterestedIn: 'x,y',
        estimatedValue: 200,
        notes: null,
        externalThreadId: null,
        aiConfidence: null,
        aiExtracted: {
          'matches': [
            {'variantName': 'X', 'query': 'x', 'quantity': 1},
            {'variantName': 'Y', 'query': 'y', 'quantity': 1},
          ],
        },
      );
      final seeds = proformaSeedsFromLead(lead);
      expect(seeds.length, 2);
      expect(seeds.every((s) => s.unitPrice == 100.0), isTrue);
    });
  });
}

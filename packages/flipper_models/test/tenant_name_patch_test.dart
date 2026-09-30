import 'package:flipper_models/services/tenant_name_patch.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _doc() => {
      'id': 'u1',
      'businesses': [
        {
          'id': 'b1',
          'name': 'Old Biz',
          'branches': [
            {'id': 'br1', 'name': 'Old Branch'},
            {'id': 'br2', 'name': 'Other'},
          ],
        },
        {
          'id': 'b2',
          'name': 'Second Biz',
          'branches': <dynamic>[],
        },
      ],
    };

void main() {
  group('patchUserAccessNames', () {
    test('renames the matching business only', () {
      final doc = _doc();
      expect(patchUserAccessNames(doc, businessId: 'b1', name: 'New Biz'),
          isTrue);
      expect(doc['businesses'][0]['name'], 'New Biz');
      expect(doc['businesses'][1]['name'], 'Second Biz');
      expect(doc['businesses'][0]['branches'][0]['name'], 'Old Branch');
    });

    test('renames the matching nested branch only', () {
      final doc = _doc();
      expect(patchUserAccessNames(doc, branchId: 'br1', name: 'New Branch'),
          isTrue);
      expect(doc['businesses'][0]['branches'][0]['name'], 'New Branch');
      expect(doc['businesses'][0]['branches'][1]['name'], 'Other');
      expect(doc['businesses'][0]['name'], 'Old Biz');
    });

    test('unknown id or unchanged name reports no change', () {
      final doc = _doc();
      expect(patchUserAccessNames(doc, businessId: 'nope', name: 'X'), isFalse);
      expect(patchUserAccessNames(doc, branchId: 'nope', name: 'X'), isFalse);
      expect(patchUserAccessNames(doc, businessId: 'b1', name: 'Old Biz'),
          isFalse);
      expect(doc, _doc());
    });

    test('null, empty or blank names never overwrite', () {
      final doc = _doc();
      for (final name in [null, '', '   ']) {
        expect(patchUserAccessNames(doc, businessId: 'b1', name: name),
            isFalse);
        expect(patchUserAccessNames(doc, branchId: 'br1', name: name),
            isFalse);
      }
      expect(doc, _doc());
    });

    test('tolerates docs without businesses or malformed entries', () {
      expect(patchUserAccessNames({}, businessId: 'b1', name: 'X'), isFalse);
      expect(
        patchUserAccessNames({
          'businesses': ['junk', {'id': 'b1'}]
        }, businessId: 'b1', name: 'X'),
        isTrue,
      );
    });

    test('trims surrounding whitespace', () {
      final doc = _doc();
      patchUserAccessNames(doc, businessId: 'b1', name: '  Trimmed  ');
      expect(doc['businesses'][0]['name'], 'Trimmed');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/counter.model.dart';

// flutter test test/counter_ditto_adapter_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('Counter.toDittoDocument', () {
    test('encodes all relevant fields', () {
      final createdAt = DateTime.utc(2025, 1, 1, 12, 0, 0);
      final lastTouched = createdAt.add(const Duration(minutes: 5));

      final counter = Counter(
        id: 'counter-1',
        branchId: '1',
        businessId: '10',
        receiptType: 'SALES',
        totRcptNo: 100,
        curRcptNo: 50,
        invcNo: 20,
        createdAt: createdAt,
        lastTouched: lastTouched,
        bhfId: 'BHF-1',
      );

      final document = counter.toDittoDocument();

      expect(document['_id'], equals('counter-1'));
      expect(document['id'], equals('counter-1'));
      expect(document['branchId'], equals('1'));
      expect(document['businessId'], equals('10'));
      expect(document['receiptType'], equals('SALES'));
      expect(document['totRcptNo'], equals(100));
      expect(document['curRcptNo'], equals(50));
      expect(document['invcNo'], equals(20));
      expect(document['bhfId'], equals('BHF-1'));
      expect(document['createdAt'], equals(createdAt.toIso8601String()));
      expect(document['lastTouched'], equals(lastTouched.toIso8601String()));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/counter.model.dart';

void main() {
  final adapter = CounterDittoAdapter.instance;

  setUp(() {
    adapter.overrideBranchIdProvider(() => 1);
    adapter.overrideBusinessIdProvider(() => 10);
  });

  tearDown(() {
    adapter.resetOverrides();
  });

  group('CounterDittoAdapter', () {
    test('toDittoDocument encodes all relevant fields', () async {
      final createdAt = DateTime.utc(2025, 1, 1, 12, 0, 0);
      final lastTouched = createdAt.add(const Duration(minutes: 5));

      final counter = Counter(
        id: 'counter-1',
        branchId: 1,
        businessId: 10,
        receiptType: 'SALES',
        totRcptNo: 100,
        curRcptNo: 50,
        invcNo: 20,
        createdAt: createdAt,
        lastTouched: lastTouched,
        bhfId: 'BHF-1',
      );

      final document = await adapter.toDittoDocument(counter);

      expect(document['id'], equals('counter-1'));
      expect(document['branchId'], equals(1));
      expect(document['businessId'], equals(10));
      expect(document['receiptType'], equals('SALES'));
      expect(document['totRcptNo'], equals(100));
      expect(document['curRcptNo'], equals(50));
      expect(document['invcNo'], equals(20));
      expect(document['bhfId'], equals('BHF-1'));
      expect(document['createdAt'], equals(createdAt.toIso8601String()));
      expect(document['lastTouched'], equals(lastTouched.toIso8601String()));
    });

    test('fromDittoDocument returns counter when branch matches', () async {
      final result = await adapter.fromDittoDocument({
        '_id': 'counter-remote',
        'branchId': 1,
        'businessId': 10,
        'receiptType': 'SALES',
        'totRcptNo': 120,
        'curRcptNo': 60,
        'invcNo': 30,
        'bhfId': 'BHF-1',
        'createdAt': '2025-01-01T12:00:00.000Z',
        'lastTouched': '2025-01-01T12:05:00.000Z',
      });

      expect(result, isNotNull);
      expect(result!.id, equals('counter-remote'));
      expect(result.branchId, equals(1));
      expect(result.businessId, equals(10));
      expect(result.receiptType, equals('SALES'));
      expect(result.totRcptNo, equals(120));
      expect(result.curRcptNo, equals(60));
      expect(result.invcNo, equals(30));
      expect(result.bhfId, equals('BHF-1'));
    });

    test('fromDittoDocument returns null when branch differs', () async {
      final result = await adapter.fromDittoDocument({
        '_id': 'counter-remote',
        'branchId': 2,
        'businessId': 10,
        'receiptType': 'SALES',
        'totRcptNo': 120,
        'curRcptNo': 60,
        'invcNo': 30,
        'bhfId': 'BHF-1',
      });

      expect(result, isNull);
    });

    test('shouldApplyRemote respects branch filter', () async {
      expect(await adapter.shouldApplyRemote({'branchId': 1}), isTrue);
      expect(await adapter.shouldApplyRemote({'branchId': 2}), isFalse);
    });
  });
}

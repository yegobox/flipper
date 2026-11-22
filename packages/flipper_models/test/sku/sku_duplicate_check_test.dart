import 'package:flipper_models/sku/sku_duplicate_check.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/sku/sku_duplicate_check_test.dart
void main() {
  const candidate = SkuHolder(
    id: 'new',
    branchId: 'A',
    productId: 'p1',
    itemCd: 'RW2NT0000001',
    bcd: '6001234567890',
  );

  group('skuNeedsDuplicateCheck', () {
    test('a new or changed SKU is checked', () {
      expect(skuNeedsDuplicateCheck(typed: 'BEV-00042'), isTrue);
      expect(skuNeedsDuplicateCheck(typed: 'BEV-2', stored: 'BEV-1'), isTrue);
    });

    // Legacy SKUs were per branch: branch A's "42" and branch B's "42" are
    // usually different items. Re-saving an old item must not be blocked.
    test('an unchanged SKU is never checked (trimmed, any case)', () {
      expect(skuNeedsDuplicateCheck(typed: '42', stored: '42'), isFalse);
      expect(
        skuNeedsDuplicateCheck(typed: ' bev-00042 ', stored: 'BEV-00042'),
        isFalse,
      );
    });

    test('a blank SKU is not checked (assigned on save)', () {
      expect(skuNeedsDuplicateCheck(typed: '  ', stored: 'X'), isFalse);
      expect(skuNeedsDuplicateCheck(typed: null), isFalse);
    });
  });

  group('findSkuClash', () {
    test('no holders, no clash', () {
      expect(findSkuClash(candidate: candidate, holders: []), isNull);
    });

    test('the candidate itself never counts', () {
      expect(
        findSkuClash(
          candidate: candidate,
          holders: [const SkuHolder(id: 'new', branchId: 'A', productId: 'x')],
        ),
        isNull,
      );
    });

    group('same branch: any other variant blocks', () {
      test('a different item', () {
        const other = SkuHolder(id: 'v2', branchId: 'A', productId: 'p9');
        expect(
          findSkuClash(candidate: candidate, holders: [other]),
          same(other),
        );
      });

      test('even a sibling variant of the same product', () {
        const sibling = SkuHolder(
          id: 'v2',
          branchId: 'A',
          productId: 'p1',
          itemCd: 'RW2NT0000001',
          bcd: '6001234567890',
        );
        expect(
          findSkuClash(candidate: candidate, holders: [sibling]),
          same(sibling),
        );
      });
    });

    group('other branches: the same item may share the SKU', () {
      test('same productId', () {
        expect(
          findSkuClash(
            candidate: candidate,
            holders: [
              const SkuHolder(id: 'v2', branchId: 'B', productId: 'p1'),
            ],
          ),
          isNull,
        );
      });

      test('same non-empty itemCd', () {
        expect(
          findSkuClash(
            candidate: candidate,
            holders: [
              const SkuHolder(
                id: 'v2',
                branchId: 'B',
                productId: 'p7',
                itemCd: 'RW2NT0000001',
              ),
            ],
          ),
          isNull,
        );
      });

      test('same non-empty bcd', () {
        expect(
          findSkuClash(
            candidate: candidate,
            holders: [
              const SkuHolder(
                id: 'v2',
                branchId: 'B',
                productId: 'p7',
                bcd: '6001234567890',
              ),
            ],
          ),
          isNull,
        );
      });

      test('a different item blocks', () {
        const other = SkuHolder(
          id: 'v2',
          branchId: 'B',
          productId: 'p7',
          itemCd: 'RW2NT0000099',
          bcd: '6009999999999',
        );
        expect(
          findSkuClash(candidate: candidate, holders: [other]),
          same(other),
        );
      });

      test('empty codes never make two items the same', () {
        const blank = SkuHolder(id: 'c', branchId: 'A', productId: 'p1');
        const other = SkuHolder(
          id: 'v2',
          branchId: 'B',
          productId: 'p7',
          itemCd: '',
          bcd: ' ',
        );
        expect(findSkuClash(candidate: blank, holders: [other]), same(other));
      });
    });
  });

  group('checkSkuDuplicate', () {
    test('one query over every branch of the business', () async {
      final calls = <(String, Map<String, dynamic>)>[];
      final clash = await checkSkuDuplicate(
        sku: ' BEV-00042 ',
        candidate: candidate,
        branchIds: ['A', 'B', 'C'],
        query: (sql, args) async {
          calls.add((sql, args));
          return [
            {'_id': 'v9', 'name': 'Fanta', 'branchId': 'C', 'productId': 'p3'},
          ];
        },
      );
      expect(calls, hasLength(1));
      expect(calls.single.$1, kSkuHoldersQuery);
      expect(calls.single.$2['sku'], 'bev-00042');
      expect(calls.single.$2['branchIds'], ['A', 'B', 'C']);
      expect(clash?.id, 'v9');
      expect(clash?.name, 'Fanta');
    });

    test('an unchanged SKU is not even queried', () async {
      var queried = false;
      final clash = await checkSkuDuplicate(
        sku: '42',
        storedSku: '42',
        candidate: candidate,
        branchIds: ['A'],
        query: (_, __) async {
          queried = true;
          return const [];
        },
      );
      expect(clash, isNull);
      expect(queried, isFalse);
    });

    test("the candidate's own branch is always included", () async {
      late Map<String, dynamic> args;
      await checkSkuDuplicate(
        sku: 'X-1',
        candidate: candidate,
        branchIds: const [],
        query: (_, a) async {
          args = a;
          return const [];
        },
      );
      expect(args['branchIds'], ['A']);
    });
  });
}

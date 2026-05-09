import 'package:flipper_models/sync/stock_recount_rra_validation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// [StockRecountMixin] imports this validation (flipper_models); Capella uses same mixin.
Variant _variant({
  String? itemCd,
  String? itemClsCd,
  String? itemNm,
  String? itemTyCd,
}) {
  return Variant(
    branchId: 'branch-1',
    name: 'Amplifier',
    itemCd: itemCd,
    itemClsCd: itemClsCd,
    itemNm: itemNm,
    itemTyCd: itemTyCd,
  );
}

void main() {
  group('missingRraIdentifiersMessageForStockRecountIo', () {
    test('returns null when RRA identifiers are present', () {
      final v = _variant(
        itemCd: 'RW0123456789012',
        itemClsCd: '5020230602',
        itemNm: 'Amplifier NM',
      );
      expect(missingRraIdentifiersMessageForStockRecountIo(v), isNull);
    });

    test('returns message when itemCd is null', () {
      final v = _variant(
        itemClsCd: '5020230602',
        itemNm: 'Amplifier NM',
      );
      expect(
        missingRraIdentifiersMessageForStockRecountIo(v),
        contains('itemCd'),
      );
    });

    test('returns message when itemCd is empty or literal null string', () {
      expect(
        missingRraIdentifiersMessageForStockRecountIo(
          _variant(
            itemCd: '',
            itemClsCd: '5020230602',
            itemNm: 'n',
          ),
        ),
        isNotNull,
      );
      expect(
        missingRraIdentifiersMessageForStockRecountIo(
          _variant(
            itemCd: 'null',
            itemClsCd: '5020230602',
            itemNm: 'n',
          ),
        ),
        isNotNull,
      );
    });

    test('returns message when itemClsCd or itemNm is missing', () {
      expect(
        missingRraIdentifiersMessageForStockRecountIo(
          _variant(
            itemCd: 'RW01',
            itemNm: 'n',
          ),
        ),
        contains('itemClsCd'),
      );
      expect(
        missingRraIdentifiersMessageForStockRecountIo(
          _variant(
            itemCd: 'RW01',
            itemClsCd: '5020230602',
          ),
        ),
        contains('itemNm'),
      );
    });
  });
}

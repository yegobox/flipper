import 'package:flipper_models/sync/capella/favorite_ditto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

void main() {
  group('favourite Ditto mapping', () {
    test('round-trips every persisted field', () {
      final touched = DateTime.utc(2026, 8, 8, 9, 30);
      final deleted = DateTime.utc(2026, 8, 9);
      final favorite = Favorite(
        id: 'fav-1',
        favIndex: '3',
        productId: 'product-9',
        branchId: 'branch-7',
        lastTouched: touched,
        deletedAt: deleted,
      );

      final back = favoriteFromDittoDoc(favoriteToDittoDoc(favorite));

      expect(back.id, 'fav-1');
      expect(back.favIndex, '3');
      expect(back.productId, 'product-9');
      expect(back.branchId, 'branch-7');
      expect(back.lastTouched, touched);
      expect(back.deletedAt, deleted);
    });

    test('writes _id alongside id so ON ID CONFLICT can match', () {
      final doc = favoriteToDittoDoc(Favorite(id: 'fav-9'));
      expect(doc['_id'], 'fav-9');
      expect(doc['id'], 'fav-9');
    });

    test('falls back to _id when the doc has no id field', () {
      expect(favoriteFromDittoDoc({'_id': 'fav-9'}).id, 'fav-9');
    });

    test('keeps favIndex a string — slot "01" must not become 1', () {
      final back = favoriteFromDittoDoc({'_id': 'f', 'favIndex': '01'});
      expect(back.favIndex, '01');
    });

    test('tolerates a malformed date instead of throwing', () {
      final back =
          favoriteFromDittoDoc({'_id': 'f', 'lastTouched': 'not-a-date'});
      expect(back.lastTouched, isNull);
    });

    test('leaves optional fields null when absent', () {
      final back = favoriteFromDittoDoc({'_id': 'f'});
      expect(back.favIndex, isNull);
      expect(back.productId, isNull);
      expect(back.branchId, isNull);
      expect(back.deletedAt, isNull);
    });
  });
}

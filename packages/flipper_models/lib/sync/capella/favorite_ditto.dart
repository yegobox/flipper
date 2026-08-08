/// Ditto document mapping for the `favorites` collection.
///
/// Favourites are the POS keypad shortcuts: `favIndex` is the slot ("1".."9")
/// and `productId` is what it points at. They are written to Ditto and
/// mirrored to Brick, which is what still carries them to Supabase — there is
/// no `@DittoAdapter` on [Favorite] and `favorites` is not in data-connector's
/// `SYNC_TABLES`.
library;

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:supabase_models/brick/models/all_models.dart';

const String favoritesCollection = 'favorites';

DateTime? _dateOrNull(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

Map<String, dynamic> favoriteToDittoDoc(Favorite favorite) => {
      '_id': favorite.id,
      'id': favorite.id,
      'favIndex': favorite.favIndex,
      'productId': favorite.productId,
      'branchId': favorite.branchId,
      'lastTouched': favorite.lastTouched?.toIso8601String(),
      'deletedAt': favorite.deletedAt?.toIso8601String(),
    };

Favorite favoriteFromDittoDoc(Map<String, dynamic> doc) => Favorite(
      id: (doc['id'] ?? doc['_id'])?.toString(),
      favIndex: doc['favIndex']?.toString(),
      productId: doc['productId']?.toString(),
      branchId: doc['branchId']?.toString(),
      lastTouched: _dateOrNull(doc['lastTouched']),
      deletedAt: _dateOrNull(doc['deletedAt']),
    );

/// `dittoInstance|branchId` pairs already subscribed — registering per read
/// leaks subscriptions until sync stalls. Keyed by instance so a recreated
/// Ditto singleton can register its own subscriptions instead of being skipped.
final Set<String> _favoritesSubscribed = <String>{};

Future<void> ensureFavoritesSubscription(Ditto ditto, String branchId) async {
  final key = '${identityHashCode(ditto)}|$branchId';
  if (!_favoritesSubscribed.add(key)) return;
  try {
    final prepared = prepareDqlSyncSubscription(
      'SELECT * FROM $favoritesCollection WHERE branchId = :branchId',
      {'branchId': branchId},
    );
    await ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
  } catch (_) {
    _favoritesSubscribed.remove(key);
  }
}

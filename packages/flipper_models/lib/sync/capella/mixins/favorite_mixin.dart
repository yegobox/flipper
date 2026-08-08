import 'package:flipper_services/proxy.dart';
import 'dart:async';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/capella/capella_brick_mirror.dart';
import 'package:flipper_models/sync/capella/favorite_ditto.dart';
import 'package:flipper_models/sync/interfaces/favorite_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

/// Ditto-native favourites (POS keypad shortcuts).
///
/// Reads are Ditto-first with a one-time backfill: pre-migration installs hold
/// these rows in SQLite only, so an empty Ditto result falls back to Brick and
/// seeds Ditto from it rather than blanking the user's keypad.
///
/// Lookups by `favIndex` are scoped to the current branch. The Brick versions
/// queried `favIndex` globally, which returns another branch's shortcut for a
/// multi-branch business — slot "1" is not unique across branches.
mixin CapellaFavoriteMixin implements FavoriteInterface {
  Repository get repository;
  Talker get talker;

  DittoService get dittoService => DittoService.instance;

  String? get _branchId => ProxyService.box.getBranchId();

  Future<void> _upsert(Ditto ditto, Favorite favorite) =>
      ditto.store.execute(
        'INSERT INTO $favoritesCollection DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {'doc': favoriteToDittoDoc(favorite)},
      );

  /// Ditto rows for [branchId], seeding from Brick the first time they are
  /// missing. Returns null when Ditto is unavailable so callers can fall back.
  Future<List<Favorite>?> _favoritesForBranch(String branchId) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return null;

    await ensureFavoritesSubscription(ditto, branchId);
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM $favoritesCollection WHERE branchId = :branchId',
        arguments: {'branchId': branchId},
      );
      if (result.items.isNotEmpty) {
        return result.items
            .map((d) => favoriteFromDittoDoc(Map<String, dynamic>.from(d.value)))
            .toList();
      }
    } catch (e, s) {
      talker.error('Ditto favourites read failed: $e', e, s);
      return null;
    }

    final existing = await ProxyService.legacyStrategy.getFavorites();
    for (final favorite in existing) {
      await _upsert(ditto, favorite);
    }
    return existing.where((f) => f.branchId == branchId).toList();
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    final branchId = _branchId;
    if (branchId == null) return ProxyService.legacyStrategy.getFavorites();
    return await _favoritesForBranch(branchId) ??
        await ProxyService.legacyStrategy.getFavorites();
  }

  @override
  Future<Favorite?> getFavoriteById({required String favId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      return ProxyService.legacyStrategy.getFavoriteById(favId: favId);
    }
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM $favoritesCollection WHERE _id = :id LIMIT 1',
        arguments: {'id': favId},
      );
      if (result.items.isNotEmpty) {
        return favoriteFromDittoDoc(
          Map<String, dynamic>.from(result.items.first.value),
        );
      }
    } catch (e, s) {
      talker.error('Ditto getFavoriteById($favId) failed: $e', e, s);
    }
    final favorite =
        await ProxyService.legacyStrategy.getFavoriteById(favId: favId);
    if (favorite != null) await _upsert(ditto, favorite);
    return favorite;
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
    final branchId = _branchId;
    if (branchId == null) {
      return ProxyService.legacyStrategy.getFavoriteByProdId(prodId: prodId);
    }
    final favorites = await _favoritesForBranch(branchId);
    if (favorites == null) {
      return ProxyService.legacyStrategy.getFavoriteByProdId(prodId: prodId);
    }
    return favorites.where((f) => f.productId == prodId).firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required String favIndex}) async {
    final branchId = _branchId;
    if (branchId == null) {
      return ProxyService.legacyStrategy.getFavoriteByIndex(favIndex: favIndex);
    }
    final favorites = await _favoritesForBranch(branchId);
    if (favorites == null) {
      return ProxyService.legacyStrategy.getFavoriteByIndex(favIndex: favIndex);
    }
    return favorites.where((f) => f.favIndex == favIndex).firstOrNull;
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex}) {
    final ditto = dittoService.dittoInstance;
    final branchId = _branchId;
    if (ditto == null || branchId == null) {
      return ProxyService.legacyStrategy
          .getFavoriteByIndexStream(favIndex: favIndex);
    }

    final controller = StreamController<Favorite?>.broadcast();
    const query =
        'SELECT * FROM $favoritesCollection WHERE branchId = :branchId AND favIndex = :favIndex';
    final arguments = {'branchId': branchId, 'favIndex': favIndex};

    // Plain nullable, not `late`: onCancel can fire before the async closure
    // below has registered the observer.
    dynamic observer;
    var cancelled = false;
    () async {
      await ensureFavoritesSubscription(ditto, branchId);
      // The last listener can cancel while the subscription above is still
      // registering. onCancel has already run by then and will not run again,
      // so registering an observer now would leak it.
      if (cancelled) return;
      observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (controller.isClosed) return;
          controller.add(
            result.items.isEmpty
                ? null
                : favoriteFromDittoDoc(
                    Map<String, dynamic>.from(result.items.first.value),
                  ),
          );
        },
      );
    }();

    // Await the observer teardown before closing, so the controller does not
    // outlive its last listener with a live observer still feeding it.
    controller.onCancel = () async {
      cancelled = true;
      await observer?.cancel();
      await controller.close();
    };
    return controller.stream;
  }

  @override
  Future<int> addFavorite({required Favorite data}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return ProxyService.legacyStrategy.addFavorite(data: data);

    final branchId = data.branchId ?? _branchId;
    // A slot can only hold one product: reuse the row already in that slot so
    // re-assigning a shortcut repoints it instead of stacking a second row.
    final existing = branchId == null
        ? null
        : (await _favoritesForBranch(branchId))
            ?.where((f) => f.favIndex == data.favIndex)
            .firstOrNull;

    final row = existing ?? data;
    row.productId = data.productId;
    row.branchId = branchId;
    row.lastTouched = DateTime.now().toUtc();

    await _upsert(ditto, row);
    // Brick is still what carries `favorites` to Supabase.
    scheduleCapellaBrickMirror(repository, row);
    return 200;
  }

  @override
  Future<int> deleteFavoriteByIndex({required String favIndex}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      return ProxyService.legacyStrategy
          .deleteFavoriteByIndex(favIndex: favIndex);
    }

    final favorite = await getFavoriteByIndex(favIndex: favIndex);
    if (favorite == null) {
      // The Brick version dereferenced a null here and threw.
      talker.warning('deleteFavoriteByIndex: no favourite in slot $favIndex');
      return 200;
    }

    await ditto.store.execute(
      'DELETE FROM $favoritesCollection WHERE _id = :id',
      arguments: {'id': favorite.id},
    );
    unawaited(
      repository.delete<Favorite>(favorite).catchError((Object e) {
        talker.warning('Brick favourite delete mirror failed: $e');
        return false;
      }),
    );
    return 200;
  }
}

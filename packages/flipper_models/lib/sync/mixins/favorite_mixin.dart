import 'dart:async';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/sync/interfaces/favorite_interface.dart';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:supabase_models/brick/repository.dart';

mixin FavoriteMixin implements FavoriteInterface {
  Repository get repository;

  @override
  Future<int> addFavorite({required Favorite data}) async {
    await repository.upsert<Favorite>(data);
    return 200; // Success status code
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    return await repository.get<Favorite>();
  }

  @override
  Future<Favorite?> getFavoriteById({required String favId}) async {
    final query = brick.Query(where: [brick.Where('id').isExactly(favId)]);
    final favorites = await repository.get<Favorite>(query: query);
    return favorites.firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
    final query =
        brick.Query(where: [brick.Where('productId').isExactly(prodId)]);
    final favorites = await repository.get<Favorite>(query: query);
    return favorites.firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required String favIndex}) async {
    final query =
        brick.Query(where: [brick.Where('favIndex').isExactly(favIndex)]);
    final favorites = await repository.get<Favorite>(query: query);
    return favorites.firstOrNull;
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex}) {
    return repository
        .subscribe<Favorite>(
          query:
              brick.Query(where: [brick.Where('favIndex').isExactly(favIndex)]),
        )
        .map((favorites) => favorites.firstOrNull);
  }

  @override
  Future<int> deleteFavoriteByIndex({required String favIndex}) async {
    final favorite = await getFavoriteByIndex(favIndex: favIndex);
    if (favorite != null) {
      await repository.delete<Favorite>(favorite);
      return 200; // Success status code
    }
    return 404; // Not found status code
  }
}

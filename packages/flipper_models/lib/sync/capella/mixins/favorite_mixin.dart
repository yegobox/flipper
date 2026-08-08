import 'package:flipper_services/proxy.dart';
import 'dart:async';
import 'package:flipper_models/sync/interfaces/favorite_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaFavoriteMixin implements FavoriteInterface {
  Repository get repository;
  Talker get talker;

  // TODO(ditto-migration): port `addFavorite` to Ditto.
  @override
  Future<int> addFavorite({required Favorite data}) async {
    return ProxyService.legacyStrategy.addFavorite(data: data);
  }

  // TODO(ditto-migration): port `getFavorites` to Ditto.
  @override
  Future<List<Favorite>> getFavorites() async {
    return ProxyService.legacyStrategy.getFavorites();
  }

  // TODO(ditto-migration): port `getFavoriteById` to Ditto.
  @override
  Future<Favorite?> getFavoriteById({required String favId}) async {
    return ProxyService.legacyStrategy.getFavoriteById(favId: favId);
  }

  // TODO(ditto-migration): port `getFavoriteByProdId` to Ditto.
  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
    return ProxyService.legacyStrategy.getFavoriteByProdId(prodId: prodId);
  }

  // TODO(ditto-migration): port `getFavoriteByIndex` to Ditto.
  @override
  Future<Favorite?> getFavoriteByIndex({required String favIndex}) async {
    return ProxyService.legacyStrategy.getFavoriteByIndex(favIndex: favIndex);
  }

  // TODO(ditto-migration): port `getFavoriteByIndexStream` to Ditto.
  @override
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex}) {
    return ProxyService.legacyStrategy.getFavoriteByIndexStream(favIndex: favIndex);
  }

  // TODO(ditto-migration): port `deleteFavoriteByIndex` to Ditto.
  @override
  Future<int> deleteFavoriteByIndex({required String favIndex}) async {
    return ProxyService.legacyStrategy.deleteFavoriteByIndex(favIndex: favIndex);
  }
}

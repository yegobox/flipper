import 'dart:async';
import 'package:flipper_models/realm_model_export.dart';

abstract class FavoriteInterface {
  Future<int> addFavorite({required Favorite data});
  Future<List<Favorite>> getFavorites();
  Future<Favorite?> getFavoriteById({required String favId});
  Future<Favorite?> getFavoriteByProdId({required String prodId});
  Future<Favorite?> getFavoriteByIndex({required String favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex});
  Future<int> deleteFavoriteByIndex({required String favIndex});
}

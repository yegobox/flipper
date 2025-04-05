import 'dart:async';
import 'package:flipper_models/sync/interfaces/favorite_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaFavoriteMixin implements FavoriteInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<int> addFavorite({required Favorite data}) async {
    throw UnimplementedError('addFavorite needs to be implemented for Capella');
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    throw UnimplementedError(
        'getFavorites needs to be implemented for Capella');
  }

  @override
  Future<Favorite?> getFavoriteById({required String favId}) async {
    throw UnimplementedError(
        'getFavoriteById needs to be implemented for Capella');
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
    throw UnimplementedError(
        'getFavoriteByProdId needs to be implemented for Capella');
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required String favIndex}) async {
    throw UnimplementedError(
        'getFavoriteByIndex needs to be implemented for Capella');
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex}) {
    throw UnimplementedError(
        'getFavoriteByIndexStream needs to be implemented for Capella');
  }

  @override
  Future<int> deleteFavoriteByIndex({required String favIndex}) async {
    throw UnimplementedError(
        'deleteFavoriteByIndex needs to be implemented for Capella');
  }
}

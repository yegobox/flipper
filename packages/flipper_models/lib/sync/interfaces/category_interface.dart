import 'dart:async';
import 'package:flipper_models/db_model_export.dart';

abstract class CategoryInterface {
  Future<List<Category>> categories({required String branchId});
  Future<Category?> category({required String id});
  Stream<List<Category>> categoryStream({String? branchId});
  FutureOr<void> addCategory({
    required String name,
    required String branchId,
    required bool active,
    required bool focused,
    required DateTime lastTouched,
    String? id,
    required DateTime createdAt,
    required dynamic deletedAt,
  });
  Future<Category> ensureUncategorizedCategory({required String branchId});
}

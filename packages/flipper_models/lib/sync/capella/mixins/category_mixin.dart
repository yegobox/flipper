import 'dart:async';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_core/query.dart' as brick;
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/capella/category_ditto_mapper.dart';
import 'package:flipper_models/sync/interfaces/category_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

/// Ditto SQL reads for categories on Capella. Applied **after** [CategoryMixin]
/// (Brick) on [CapellaSync] so listing/subscription hits local Ditto.
///
/// [addCategory] / [ensureUncategorizedCategory] are overridden here so new rows
/// are written to Brick **and** mirrored into Ditto — otherwise bulk import
/// reloads [categories] from Ditto and cannot resolve names just created via
/// [CategoryMixin] alone.
mixin CapellaCategoryDittoMixin implements CategoryInterface {
  Repository get repository;
  Talker get talker;

  DittoService get dittoService => DittoService.instance;

  Future<void> _upsertCategoryIntoDitto(Category model) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;

    final doc = <String, dynamic>{
      '_id': model.id,
      'id': model.id,
      'active': model.active,
      'focused': model.focused,
      'name': model.name,
      'branchId': model.branchId,
      'deletedAt': model.deletedAt?.toIso8601String(),
      'lastTouched': model.lastTouched?.toIso8601String(),
    };

    try {
      await ditto.store.execute(
        'INSERT INTO categories DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {'doc': doc},
      );
    } catch (e, s) {
      talker.error('Ditto categories upsert failed: $e', e, s);
    }
  }

  @override
  Future<void> addCategory({
    required String name,
    required String branchId,
    required bool active,
    required bool focused,
    required DateTime lastTouched,
    String? id,
    required DateTime createdAt,
    required dynamic deletedAt,
  }) async {
    final existing = await repository.get<Category>(
      query: brick.Query(where: [
        brick.Where('name').isExactly(name),
        brick.Where('branchId').isExactly(branchId),
      ]),
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    final Category row;
    if (existing.firstOrNull == null) {
      row = Category(
        id: id,
        focused: focused,
        name: name,
        active: active,
        branchId: branchId,
        lastTouched: lastTouched,
        deletedAt: deletedAt as DateTime?,
      );
      await repository.upsert<Category>(row);
    } else {
      row = existing.first;
    }
    await _upsertCategoryIntoDitto(row);
  }

  @override
  Future<Category> ensureUncategorizedCategory({required String branchId}) async {
    final existing = await repository.get<Category>(
      query: brick.Query(where: [
        brick.Where('name').isExactly('UnCategorized'),
        brick.Where('branchId').isExactly(branchId),
      ]),
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    if (existing.isNotEmpty) {
      final c = existing.first;
      await _upsertCategoryIntoDitto(c);
      return c;
    }

    final newCategory = Category(
      name: 'UnCategorized',
      branchId: branchId,
      focused: false,
      active: true,
      lastTouched: DateTime.now().toUtc(),
    );

    await repository.upsert<Category>(newCategory);
    await _upsertCategoryIntoDitto(newCategory);
    return newCategory;
  }

  @override
  Future<List<Category>> categories({required String branchId}) async {
    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for categories query');
      return [];
    }

    try {
      final result = await dittoService.dittoInstance!.store.execute(
        "SELECT * FROM categories WHERE branchId = :branchId",
        arguments: {"branchId": branchId},
      );

      return result.items.map((doc) {
        final data = Map<String, dynamic>.from(doc.value);
        return categoryFromDittoMap(data);
      }).toList();
    } catch (e, s) {
      talker.error('Error fetching categories: $e');
      talker.error(s);
      return [];
    }
  }

  @override
  Future<Category?> category({required String id}) async {
    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for category query');
      return null;
    }

    try {
      Future<Category?> one(String sql) async {
        final result = await dittoService.dittoInstance!.store.execute(
          sql,
          arguments: {"id": id},
        );
        if (result.items.isEmpty) return null;
        return categoryFromDittoMap(Map<String, dynamic>.from(result.items.first.value));
      }

      return await one('SELECT * FROM categories WHERE id = :id LIMIT 1') ??
          await one('SELECT * FROM categories WHERE _id = :id LIMIT 1');
    } catch (e, s) {
      talker.error('Error fetching category by id: $e');
      talker.error(s);
      return null;
    }
  }

  @override
  Stream<List<Category>> categoryStream({String? branchId}) {
    final id = branchId ?? ProxyService.box.getBranchId()!;

    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for category stream');
      return Stream.value([]);
    }

    final controller = StreamController<List<Category>>.broadcast();

    const query = "SELECT * FROM categories WHERE branchId = :branchId";
    final arguments = {"branchId": id};

    final observer = dittoService.dittoInstance!.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) {
        if (controller.isClosed) return;

        final categories = queryResult.items.map((doc) {
          final data = Map<String, dynamic>.from(doc.value);
          return categoryFromDittoMap(data);
        }).toList();

        controller.add(categories);
      },
    );

    controller.onCancel = () {
      observer.cancel();
    };

    return controller.stream;
  }
}

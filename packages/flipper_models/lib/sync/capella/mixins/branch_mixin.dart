import 'dart:async';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/sync/interfaces/branch_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_models/sync/capella/category_ditto_mapper.dart';

/// `businessId` keys (or `''` for none) already given one Brick fallback
/// attempt for a legitimately-empty `branches`/`businesses` Ditto result, so
/// repeat calls don't pay for another blocking network read every time.
final Set<String> _branchesEmptyFallbackAttempted = <String>{};
final Set<String> _businessesEmptyFallbackAttempted = <String>{};

mixin CapellaBranchMixin implements BranchInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  @override
  Future<Branch?> branch({String? name, String? serverId}) async {
    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for branch query');
      return null;
    }

    try {
      final result = await dittoService.dittoInstance!.store.execute(
        "SELECT * FROM branches WHERE id = :id",
        arguments: {"id": serverId},
      );

      if (result.items.isEmpty) return null;

      final data = Map<String, dynamic>.from(result.items.first.value);
      return Branch.fromMap(data);
    } catch (e) {
      talker.error('Error fetching branch: $e');
      return null;
    }
  }

  @override
  FutureOr<void> updateBranch({
    required String branchId,
    String? name,
    bool? active,
    bool? isDefault,
  }) async {
    if (dittoService.dittoInstance == null) {
      throw Exception('Ditto not initialized');
    }

    final existingBranch = await branch(serverId: branchId);
    if (existingBranch == null) {
      throw Exception('Branch not found');
    }

    // Manually create map from Branch properties
    final updatedData = <String, dynamic>{
      'name': name ?? existingBranch.name,
      'active': active ?? existingBranch.active ?? true,
      'isDefault': isDefault ?? existingBranch.isDefault,
    };

    await dittoService.dittoInstance!.store.execute(
      "UPDATE branches SET name = :name, active = :active, isDefault = :isDefault WHERE id = :id",
      arguments: {
        "id": branchId,
        "name": updatedData['name'],
        "active": updatedData['active'],
        "isDefault": updatedData['isDefault'],
      },
    );

    talker.info('Updated branch: $branchId');
  }

  @override
  Future<void> saveBranch(Branch branch) async {
    if (dittoService.dittoInstance == null) {
      throw Exception('Ditto not initialized');
    }

    await dittoService.dittoInstance!.store.execute(
      "INSERT OR REPLACE INTO branches (id, name, businessId, location, description, longitude, latitude, isDefault, active, serverId, lastTouched) VALUES (:id, :name, :businessId, :location, :description, :longitude, :latitude, :isDefault, :active, :serverId, :lastTouched)",
      arguments: {
        "id": branch.id,
        "name": branch.name ?? '',
        "businessId": branch.businessId ?? '',
        "location": branch.location ?? '',
        "description": branch.description ?? '',
        "longitude": branch.longitude ?? 0,
        "latitude": branch.latitude ?? 0,
        "isDefault": branch.isDefault ?? false,
        "active": branch.active ?? true,
        "serverId": branch.serverId ?? 0,
        "lastTouched": DateTime.now().toIso8601String(),
      },
    );

    talker.info('Saved branch: ${branch.id}');
  }

  /// Brick-backed read used when the caller allows a non-local lookup
  /// (`localOnly: false`) but the local Ditto store has nothing to offer —
  /// e.g. a fresh device, where `branches` is send-only and therefore never
  /// replicated down.
  Future<List<Branch>> _branchesFromBrick({
    String? businessId,
    bool? active,
    String? excludeId,
  }) async {
    try {
      return await repository.get<Branch>(
        query: Query(
          where: [
            if (businessId != null) Where('businessId').isExactly(businessId),
            if (excludeId != null) Where('id').isNot(excludeId),
            if (active != null) Where('active').isExactly(active),
          ],
        ),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );
    } catch (e, s) {
      talker.error('Brick branches fallback failed: $e');
      talker.error(s);
      return [];
    }
  }

  @override
  Future<List<Branch>> branches({
    String? businessId,
    // No default: `null` means "don't filter on active" so callers that omit
    // it get every branch rather than the inactive ones only.
    bool? active,
    String? excludeId,
    bool localOnly = false,
  }) async {
    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for branches query');
      return localOnly
          ? <Branch>[]
          : _branchesFromBrick(
              businessId: businessId,
              active: active,
              excludeId: excludeId,
            );
    }

    try {
      String query = "SELECT * FROM branches WHERE 1=1";
      final arguments = <String, dynamic>{};

      if (businessId != null) {
        query += " AND businessId = :businessId";
        arguments['businessId'] = businessId;
      }

      if (active != null) {
        // `active` is stored as a CBOR boolean by the Ditto adapter, so it must
        // be bound as a bool — binding 1/0 never matches under DQL strict mode.
        query += " AND active = :active";
        arguments['active'] = active;
      }

      if (excludeId != null) {
        query += " AND id != :excludeId";
        arguments['excludeId'] = excludeId;
      }

      final result = await dittoService.dittoInstance!.store.execute(
        query,
        arguments: arguments,
      );

      final branches = result.items
          .map((doc) => Branch.fromMap(Map<String, dynamic>.from(doc.value)))
          .toList();

      if (branches.isEmpty &&
          !localOnly &&
          _branchesEmptyFallbackAttempted.add(businessId ?? '')) {
        return _branchesFromBrick(
          businessId: businessId,
          active: active,
          excludeId: excludeId,
        );
      }
      return branches;
    } catch (e, s) {
      talker.error('Error fetching branches: $e');
      talker.error(s);
      return localOnly
          ? <Branch>[]
          : _branchesFromBrick(
              businessId: businessId,
              active: active,
              excludeId: excludeId,
            );
    }
  }

  @override
  void clearData({required ClearData data, required String identifier}) async {
    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for clearData');
      return;
    }

    try {
      if (data == ClearData.Branch) {
        await dittoService.dittoInstance!.store.execute(
          "DELETE FROM branches WHERE id = :id",
          arguments: {"id": identifier},
        );
        talker.info('Cleared branch data: $identifier');
      }

      if (data == ClearData.Business) {
        await dittoService.dittoInstance!.store.execute(
          "DELETE FROM businesses WHERE id = :id",
          arguments: {"id": identifier},
        );
        talker.info('Cleared business data: $identifier');
      }
    } catch (e, s) {
      talker.error('Failed to clear data: $e');
      talker.error('Stack trace: $s');
    }
  }

  @override
  Future<List<Business>> businesses({
    String? userId,
    bool fetchOnline = false,
    bool active = false,
  }) async {
    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for businesses query');
      return fetchOnline
          ? _businessesFromBrick(userId: userId, active: active)
          : <Business>[];
    }

    try {
      String query = "SELECT * FROM businesses WHERE 1=1";
      final arguments = <String, dynamic>{};

      if (userId != null) {
        query += " AND userId = :userId";
        arguments['userId'] = userId;
      }

      if (active) {
        // Stored as a CBOR boolean — see the note in `branches`.
        query += " AND active = :active";
        arguments['active'] = true;
      }

      final result = await dittoService.dittoInstance!.store.execute(
        query,
        arguments: arguments,
      );

      final businesses = result.items
          .map((doc) => Business.fromMap(Map<String, dynamic>.from(doc.value)))
          .toList();

      if (businesses.isEmpty &&
          fetchOnline &&
          _businessesEmptyFallbackAttempted.add(userId ?? '')) {
        return _businessesFromBrick(userId: userId, active: active);
      }
      return businesses;
    } catch (e, s) {
      talker.error('Error fetching businesses: $e');
      talker.error(s);
      return fetchOnline
          ? _businessesFromBrick(userId: userId, active: active)
          : <Business>[];
    }
  }

  /// Brick-backed read used when the caller opted into a remote lookup
  /// (`fetchOnline: true`) but the local Ditto store came back empty.
  Future<List<Business>> _businessesFromBrick({
    String? userId,
    bool active = false,
  }) async {
    try {
      return await repository.get<Business>(
        query: Query(
          where: [
            if (userId != null) Where('userId').isExactly(userId),
            if (active) Where('active').isExactly(true),
          ],
        ),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );
    } catch (e, s) {
      talker.error('Brick businesses fallback failed: $e');
      talker.error(s);
      return [];
    }
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
  Stream<List<Category>> categoryStream({String? branchId}) {
    final id = branchId ?? ProxyService.box.getBranchId()!;

    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for category stream');
      return Stream.value([]);
    }

    final controller = StreamController<List<Category>>.broadcast();

    final query = "SELECT * FROM categories WHERE branchId = :branchId";
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

  @override
  Future<Branch> activeBranch({required String branchId}) async {
    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for active branch');
      return Branch(
        id: branchId,
        name: 'Branch',
        businessId: '',
        isDefault: false,
      );
    }

    try {
      final result = await dittoService.dittoInstance!.store.execute(
        "SELECT * FROM branches WHERE id = :id",
        arguments: {"id": branchId},
      );

      if (result.items.isEmpty) {
        // Return default branch if none found
        return Branch(
          id: branchId,
          name: 'Branch',
          businessId: '',
          isDefault: false,
        );
      }

      final data = Map<String, dynamic>.from(result.items.first.value);
      return Branch.fromMap(data);
    } catch (e) {
      talker.error('Error fetching active branch: $e');
      await logOut();
      rethrow;
    }
  }

  @override
  Stream<Branch> activeBranchStream({required String branchId}) {
    if (dittoService.dittoInstance == null) {
      talker.error('Ditto not initialized for active branch stream');
      return Stream.value(
        Branch(id: branchId, name: 'Branch', businessId: '', isDefault: false),
      );
    }

    final controller = StreamController<Branch>.broadcast();

    final query = "SELECT * FROM branches WHERE id = :id";
    final arguments = {"id": branchId};

    final observer = dittoService.dittoInstance!.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) {
        if (controller.isClosed) return;

        if (queryResult.items.isEmpty) {
          // Return default branch if none found
          controller.add(
            Branch(
              id: branchId,
              name: 'Branch',
              businessId: '',
              isDefault: false,
            ),
          );
        } else {
          final data = Map<String, dynamic>.from(queryResult.items.first.value);
          final branch = Branch.fromMap(data);
          controller.add(branch);
        }
      },
    );

    controller.onCancel = () {
      observer.cancel();
    };

    return controller.stream;
  }

  @override
  Future<bool> logOut();
}

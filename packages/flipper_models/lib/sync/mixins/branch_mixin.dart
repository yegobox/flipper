import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/sync/interfaces/branch_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin BranchMixin implements BranchInterface {
  Repository get repository;
  final String apihub = AppSecrets.apihubProd;

  @override
  Future<bool> logOut();

  @override
  FutureOr<Branch> addBranch(
      {required String name,
      required String businessId,
      required String location,
      String? userOwnerPhoneNumber,
      required HttpClientInterface flipperHttpClient,
      int? serverId,
      String? description,
      num? longitude,
      num? latitude,
      required bool isDefault,
      required bool active,
      DateTime? lastTouched,
      DateTime? deletedAt,
      int? id}) async {
    final response = await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/branch/create'),
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "businessId": businessId,
        "location": location
      }),
    );
    // find a branch by name create the branch if only it does not exist
    Branch? existingBranch = await branch(name: name);
    if (existingBranch != null) {
      return existingBranch;
    }
    if (response.statusCode == 201) {
      IBranch remoteBranch = IBranch.fromJson(json.decode(response.body));
      return await repository.upsert<Branch>(Branch(
        serverId: remoteBranch.serverId,
        location: location,
        description: description,
        name: name,
        businessId: businessId,
        longitude: longitude,
        latitude: latitude,
        isDefault: isDefault,
        active: active,
      ));
    }
    throw Exception('Failed to create branch');
  }

  @override
  FutureOr<Branch?> branch({String? name, String? serverId}) async {
    final repository = Repository();
    Query? query = null;
    if (name != null) {
      query = Query(where: [Where('name').isExactly(name)]);
    }
    if (serverId != null) {
      query = Query(where: [Where('id').isExactly(serverId)]);
    }
    final result = await repository.get<Branch>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    final branch = result.firstOrNull;

    return branch;
  }

  @override
  Future<void> saveBranch(Branch branch) async {
    await repository.upsert<Branch>(branch);
  }

  @override
  FutureOr<void> updateBranch(
      {required String branchId,
      String? name,
      bool? active,
      bool? isDefault}) async {
    Branch? branchs = await branch(serverId: branchId);
    if (branchs == null) {
      throw Exception('Branch not found');
    }
    branchs.active = active ?? branchs.active;
    branchs.isDefault = isDefault ?? branchs.isDefault;

    await saveBranch(branchs);
  }

  @override
  Future<List<Branch>> branches({
    String? businessId,
    bool? active = false,
    String? excludeId,
  }) async {
    return await _getBranches(businessId, excludeId: excludeId);
  }

  Future<List<Branch>> _getBranches(String? businessId,
      {String? excludeId}) async {
    final filters = <Where>[
      if (businessId != null) Where('businessId').isExactly(businessId),
      if (excludeId != null) Where('id').isNot(excludeId),
    ];
    var query = Query(where: filters);

    try {
      // First get local branches
      final localBranches = await repository.get<Branch>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: query,
      );

      return localBranches;
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  void clearData({required ClearData data, required String identifier}) async {
    try {
      if (data == ClearData.Branch) {
        final List<Branch> branches = await repository.get<Branch>(
          query: Query(where: [Where('id').isExactly(identifier)]),
        );

        for (final branch in branches) {
          await repository.delete<Branch>(
            branch,
            policy: OfflineFirstDeletePolicy.optimisticLocal,
          );
        }
      }

      if (data == ClearData.Business) {
        final List<Business> businesses = await repository.get<Business>(
          query: Query(where: [Where('id').isExactly(identifier)]),
        );

        for (final business in businesses) {
          await repository.delete<Business>(business);
        }
      }
    } catch (e, s) {
      talker.error('Failed to clear data: $e');
      talker.error('Stack trace: $s');
    }
  }

  @override
  Future<List<Business>> businesses(
      {String? userId, bool fetchOnline = false, bool active = false}) async {
    return await repository.get<Business>(
      policy: fetchOnline
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly,
      query: Query(where: [
        if (userId != null) Where('userId').isExactly(userId),
        Where('active').isExactly(active)
      ]),
    );
  }

  @override
  Future<List<Category>> categories({required String branchId}) async {
    return repository.get<Category>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
  }

  @override
  Stream<List<Category>> categoryStream({String? branchId}) {
    final id = branchId ?? ProxyService.box.getBranchId()!;
    return repository.subscribe<Category>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: Query(where: [Where('branchId').isExactly(id)]),
    );
  }

  @override
  Future<Branch> activeBranch({required String businessId}) async {
    try {
      // Use a direct query to filter for the default branch at the database level
      // Query for branches where isDefault is either true or 1
      final branches = await repository.get<Branch>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: Query(where: [Where('businessId').isExactly(businessId)]),
      );

      // If we found a default branch, return it
      if (branches.isNotEmpty) {
        return branches.first;
      }

      if (branches.isEmpty) {
        throw Exception("No default branch found");
      }

      return branches.first;
    } catch (e) {
      await logOut();
      rethrow;
    }
  }

  @override
  Stream<Branch> activeBranchStream({required String businessId}) {
    return repository
        .subscribe<Branch>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: Query(where: [Where('businessId').isExactly(businessId)]),
    )
        .map((branches) {
      final branch = branches.firstWhere(
        (branch) => branch.isDefault == true || branch.isDefault == 1,
        orElse: () => throw Exception("No default branch found"),
      );
      return branch;
    });
  }
}

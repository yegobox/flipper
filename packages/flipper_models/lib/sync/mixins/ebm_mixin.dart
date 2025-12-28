import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/interfaces/ebm_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/ebm_helper.dart';

mixin EbmMixin implements EbmInterface {
  DittoService get dittoService => DittoService.instance;
  Repository get repository;

  @override
  Future<void> saveEbm({
    required String branchId,
    required String severUrl,
    required String mrc,
    required String bhFId,
    bool vatEnabled = false,
  }) async {
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    if (business == null) {
      throw Exception("Business not found");
    }

    final query = Query(where: [
      Where('branchId').isExactly(branchId),
      Where('bhfId').isExactly(bhFId),
    ]);

    final ebm = await repository.get<Ebm>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    final existingEbm = ebm.firstOrNull;

    final resolvedTin =
        (await effectiveTin(business: business, branchId: branchId));

    Ebm updatedEbm = existingEbm ??
        Ebm(
          mrc: mrc,
          bhfId: bhFId,
          tinNumber: resolvedTin!,
          dvcSrlNo: business.dvcSrlNo ?? "vsdcyegoboxltd",
          userId: ProxyService.box.getUserId()!,
          taxServerUrl: severUrl,
          businessId: business.id,
          branchId: branchId,
          vatEnabled: vatEnabled,
        );

    if (existingEbm != null) {
      updatedEbm.taxServerUrl = severUrl;
      updatedEbm.vatEnabled = vatEnabled;
      updatedEbm.mrc = mrc;
    }

    await repository.upsert(updatedEbm);
  }

  @override
  Future<Ebm?> ebm({required String branchId, bool fetchRemote = true}) async {
    try {
      // First try to get from local repository with offline-first approach
      final query = Query(
        where: [Where('branchId').isExactly(branchId)],
      );

      List<Ebm> fetchedEbms = await repository.get<Ebm>(
        query: query,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );

      // If no data found locally and fetchRemote is true, try Ditto direct query
      if (fetchedEbms.isEmpty && fetchRemote) {
        final ditto = dittoService.dittoInstance;
        if (ditto != null) {
          const dittoQuery = 'SELECT * FROM ebms WHERE branchId = :branchId';
          final arguments = {'branchId': branchId};

          await ditto.sync
              .registerSubscription(dittoQuery, arguments: arguments);
          // Give it a moment to sync
          await Future.delayed(const Duration(milliseconds: 500));

          // Execute query directly
          final result =
              await ditto.store.execute(dittoQuery, arguments: arguments);
          final items = result.items.toList();

          if (items.isNotEmpty) {
            // Parse first result and save to local repository for future offline access
            final ebmData = items.first.value;
            final ebm = Ebm(
              id: ebmData['id'] as String? ?? ebmData['_id'] as String?,
              mrc: ebmData['mrc'] as String? ?? '',
              bhfId: ebmData['bhfId'] as String? ??
                  ebmData['bhf_id'] as String? ??
                  '',
              tinNumber: ebmData['tinNumber'] as int? ??
                  ebmData['tin_number'] as int? ??
                  0,
              dvcSrlNo: ebmData['dvcSrlNo'] as String? ??
                  ebmData['dvc_srl_no'] as String? ??
                  "",
              userId: ebmData['userId'] as String? ??
                  ebmData['user_id'] as String? ??
                  ProxyService.box.getUserId() ??
                  "",
              taxServerUrl: ebmData['taxServerUrl'] as String? ??
                  ebmData['tax_server_url'] as String? ??
                  '',
              businessId: ebmData['businessId'] as String? ??
                  ebmData['business_id'] as String? ??
                  ProxyService.box.getBusinessId() ??
                  "",
              branchId: ebmData['branchId'] as String? ??
                  ebmData['branch_id'] as String? ??
                  branchId,
              vatEnabled: ebmData['vatEnabled'] as bool? ??
                  ebmData['vat_enabled'] as bool?,
            );

            // Save to local repository to ensure offline availability
            await repository.upsert<Ebm>(ebm);
            return ebm;
          }
        }
      }

      // Return the first EBM from local repository if found
      return fetchedEbms.isNotEmpty ? fetchedEbms[0] : null;
    } catch (e, st) {
      talker.error('Error fetching EBM: $e\n$st');
      return null;
    }
  }

  @override
  Future<Product?> findProductByTenantId({required String tenantId}) async {
    final query = Query(where: [Where('bindedToTenantId').isExactly(tenantId)]);
    final result = await repository.get<Product>(query: query);
    return result.firstOrNull;
  }
}

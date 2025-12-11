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
    required int branchId,
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
          businessId: business.serverId,
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
  Future<Ebm?> ebm({required int branchId, bool fetchRemote = false}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return null;
      }

      const query = 'SELECT * FROM ebms WHERE branchId = :branchId';
      final arguments = {'branchId': branchId};

      // If fetchRemote is true, ensure sync subscription is active

      await ditto.sync.registerSubscription(query, arguments: arguments);
      // Give it a moment to sync
      await Future.delayed(const Duration(milliseconds: 500));

      // Execute query directly
      final result = await ditto.store.execute(query, arguments: arguments);
      final items = result.items.toList();

      if (items.isEmpty) return null;

      // Parse first result
      final ebmData = items.first.value;
      final ebm = Ebm(
        id: ebmData['id'] as String? ?? ebmData['_id'] as String?,
        mrc: ebmData['mrc'] as String? ?? '',
        bhfId: ebmData['bhfId'] as String? ?? ebmData['bhf_id'] as String? ?? '',
        tinNumber: ebmData['tinNumber'] as int? ?? ebmData['tin_number'] as int? ?? 0,
        dvcSrlNo: ebmData['dvcSrlNo'] as String? ?? ebmData['dvc_srl_no'] as String? ?? "",
        userId: ebmData['userId'] as int? ?? ebmData['user_id'] as int? ?? ProxyService.box.getUserId() ?? 0,
        taxServerUrl: ebmData['taxServerUrl'] as String? ?? ebmData['tax_server_url'] as String? ?? '',
        businessId: ebmData['businessId'] as int? ?? ebmData['business_id'] as int? ?? ProxyService.box.getBusinessId() ?? 0,
        branchId: ebmData['branchId'] as int? ?? ebmData['branch_id'] as int? ?? branchId,
        vatEnabled: ebmData['vatEnabled'] as bool? ?? ebmData['vat_enabled'] as bool?,
      );

      // Save to local storage if fetched from remote
      if (fetchRemote) {
        await _saveEbmToLocalStorage(ebm);
      }

      return ebm;
    } catch (e, st) {
      talker.error('Error fetching EBM from Ditto: $e\n$st');
      return null;
    }
  }

  Future<void> _saveEbmToLocalStorage(Ebm ebm) async {
    try {
      await ProxyService.box
          .writeString(key: "getServerUrl", value: ebm.taxServerUrl ?? "");
      await ProxyService.box.writeString(key: "bhfId", value: ebm.bhfId ?? "");
    } catch (e) {
      talker.warning('Failed to save EBM to local storage: $e');
    }
  }

  @override
  Future<Product?> findProductByTenantId({required String tenantId}) async {
    final query = Query(where: [Where('bindedToTenantId').isExactly(tenantId)]);
    final result = await repository.get<Product>(query: query);
    return result.firstOrNull;
  }
}
